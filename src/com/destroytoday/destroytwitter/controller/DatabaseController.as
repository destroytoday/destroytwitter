package com.destroytoday.destroytwitter.controller
{
    import com.adobe.utils.StringUtil;
    import com.destroytoday.destroytwitter.constants.PreferenceType;
    import com.destroytoday.destroytwitter.constants.StreamType;
    import com.destroytoday.destroytwitter.model.DatabaseModel;
    import com.destroytoday.destroytwitter.model.vo.AccountVO;
    import com.destroytoday.destroytwitter.model.vo.GeneralStatusVO;
    import com.destroytoday.destroytwitter.model.vo.IStreamVO;
    import com.destroytoday.destroytwitter.model.vo.QueuedCallVO;
    import com.destroytoday.destroytwitter.model.vo.SQLUserIDVO;
    import com.destroytoday.destroytwitter.model.vo.SQLUserVO;
    import com.destroytoday.destroytwitter.model.vo.ScreenNameVO;
    import com.destroytoday.destroytwitter.model.vo.StreamMessageVO;
    import com.destroytoday.destroytwitter.model.vo.StreamStatusVO;
    import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
    import com.destroytoday.destroytwitter.module.accountmodule.model.BaseAccountStreamModel;
    import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
    import com.destroytoday.destroytwitter.utils.FilterUtil;
    import com.destroytoday.pool.ObjectPool;
    import com.destroytoday.pool.ObjectWaterpark;
    import com.destroytoday.twitteraspirin.vo.DirectMessageVO;
    import com.destroytoday.twitteraspirin.vo.SearchStatusVO;
    import com.destroytoday.twitteraspirin.vo.StatusVO;
    import com.destroytoday.twitteraspirin.vo.UserVO;
    import com.probertson.data.QueuedStatement;
    import com.probertson.data.SQLRunner;
    
    import flash.data.SQLConnection;
    import flash.data.SQLResult;
    import flash.data.SQLStatement;
    import flash.errors.SQLError;
    import flash.events.SQLEvent;
    import flash.events.TimerEvent;
    import flash.net.Responder;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    import mx.utils.ObjectUtil;
    
    import org.osflash.signals.Signal;

    public class DatabaseController
    {
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
        [Inject]
        public var model:DatabaseModel;

        [Inject]
        public var preferencesController:PreferencesController;

        [Inject]
        public var signalBus:ApplicationSignalBus;

		//--------------------------------------------------------------------------
		//
		//  Signals
		//
		//--------------------------------------------------------------------------
		
		public const gotAccountList:Signal = new Signal(SQLResult);

		public const gotEmptyUserList:Signal = new Signal(SQLResult);
		
        //--------------------------------------------------------------------------
        //
        //  Constants
        //
        //--------------------------------------------------------------------------

		protected static const CREATE_TABLE_STATEMENT:String = "CREATE TABLE IF NOT EXISTS :table (:columns)";
		
		protected static const ADD_COLUMN_STATEMENT:String = "ALTER TABLE :table ADD COLUMN :column";
		
		protected static const CREATE_UNIQUE_INDEX_STATEMENT:String = "CREATE UNIQUE INDEX IF NOT EXISTS :index ON :table (:columns)";
		
		protected static const DELETE_ROWS_STATEMENT:String = "DELETE FROM :table";
		
		protected static const GET_ACCOUNT_LIST_STATEMENT:String = "SELECT * FROM `accounts` ORDER BY `active` DESC, `lastUpdated` ASC";
		
		protected static const GET_EMPTY_USER_LIST_STATEMENT:String = "SELECT `id` FROM `users` WHERE `screenName` ISNULL LIMIT :limit";
		
		protected static const GET_FRIEND_LIST_STATEMENT:String = "SELECT u.screenName FROM `friendPairs` p LEFT JOIN `users` u ON p.id=u.id WHERE p.account=:account AND u.screenName NOTNULL ORDER BY LOWER(u.screenName) ASC";
		
		protected static const BASE_GET_STREAM_MESSAGES_STATEMENT:String = "SELECT p.account, m.id, m.createdAt as timestamp, m.text, us.id as userID, us.name as userFullName, us.screenName as userScreenName, us.icon as userIcon, ur.id as recipientID, ur.name as recipientFullName, ur.screenName as recipientScreenName, ur.icon as recipientIcon, IFNULL(r.read, 0) as read FROM `t_messagePairs` p LEFT JOIN `t_messages` m ON p.id=m.id LEFT JOIN `users` us ON p.sender=us.id LEFT JOIN `users` ur ON p.recipient=ur.id LEFT JOIN `t_readMessages` r ON r.id=p.id ";
		
		protected static const BASE_GET_STREAM_STATUSES_STATEMENT:String = "SELECT p.account, s.id, s.createdAt as timestamp, s.text, s.source, s.inReplyToStatusID, s.inReplyToScreenName, s.favorited, u.id as userID, u.name as userFullName, u.screenName as userScreenName, u.icon as userIcon, IFNULL(r.read, 0) as read FROM `t_statusPairs` p LEFT JOIN `statuses` s ON p.id=s.id LEFT JOIN `users` u ON p.user=u.id LEFT JOIN `t_readStatuses` r ON r.id=p.id ";
		
		protected static const GET_STREAM_MESSAGES_STATEMENT:String = BASE_GET_STREAM_MESSAGES_STATEMENT + " WHERE p.account=:account ORDER BY m.createdAt DESC LIMIT :count";
		
		protected static const GET_SEARCH_STREAM_STATUSES_STATEMENT:String = "SELECT s.account as account, s.id as id, s.createdAt as timestamp, s.text as text, s.source as source, s.userFullName as userFullName, s.userScreenName as userScreenName, s.userIcon as userIcon, IFNULL(r.read, 0) as read FROM `t_searchStatuses` s LEFT JOIN `t_readStatuses` r ON r.id=s.id WHERE s.account=:account ORDER BY s.createdAt DESC LIMIT :count";
		
		protected static const GET_SEARCH_STREAM_STATUSES_AFTER_ID_STATEMENT:String = "SELECT * FROM (SELECT s.account as account, s.id as id, s.createdAt as timestamp, s.text as text, s.source as source, s.userFullName as userFullName, s.userScreenName as userScreenName, s.userIcon as userIcon, IFNULL(r.read, 0) as read FROM `t_searchStatuses` s LEFT JOIN `t_readStatuses` r ON r.id=s.id WHERE s.account=:account AND (length(s.id) > :length(:afterID) OR length(s.id) = :length(:afterID) AND s.id > :afterID) ORDER BY s.createdAt ASC LIMIT :count) ORDER BY timestamp DESC";
		
		protected static const GET_SEARCH_STREAM_STATUSES_BEFORE_ID_STATEMENT:String = "SELECT s.account as account, s.id as id, s.createdAt as timestamp, s.text as text, s.source as source, s.userFullName as userFullName, s.userScreenName as userScreenName, s.userIcon as userIcon, IFNULL(r.read, 0) as read FROM `t_searchStatuses` s LEFT JOIN `t_readStatuses` r ON r.id=s.id WHERE s.account=:account AND (length(s.id) < length(:beforeID) OR length(s.id) = length(:beforeID) AND s.id < :beforeID) ORDER BY s.createdAt DESC LIMIT :count";
		
		protected static const GET_SEARCH_STREAM_STATUSES_SINCE_ID_STATEMENT:String = "SELECT s.account as account, s.id as id, s.createdAt as timestamp, s.text as text, s.source as source, s.userFullName as userFullName, s.userScreenName as userScreenName, s.userIcon as userIcon, IFNULL(r.read, 0) as read FROM `t_searchStatuses` s LEFT JOIN `t_readStatuses` r ON r.id=s.id WHERE s.account=:account AND (length(s.id) > length(:sinceID) OR length(s.id) = length(:sinceID) AND s.id > :sinceID) ORDER BY s.createdAt DESC LIMIT :count";
		
		protected static const DELETE_STATUS_STATEMENT:String = "DELETE FROM `statuses` WHERE id = :id";
		
		protected static const DELETE_STATUS_PAIR_STATEMENT:String = "DELETE FROM `t_statusPairs` WHERE id = :id";
		
		protected static const DELETE_SEARCH_STATUSES_STATEMENT:String = "DELETE FROM `t_searchStatuses` WHERE `account`=:account";
		
		protected static const DELETE_ACCOUNT_STATEMENT:String = "DELETE FROM `accounts` WHERE `id`=:id";
		
		protected static const UPDATE_ACCOUNT_STATEMENT:String = "REPLACE INTO `accounts` (`id`, `screenName`, `accessToken`, `lastUpdated`, `active`) VALUES (:id, :screenName, :accessToken, :lastUpdated, :active)";
		
		protected static const GET_NEWEST_STATUS_ID_STATEMENT:String = "SELECT p.id FROM `t_statusPairs` p LEFT JOIN `statuses` s ON p.id=s.id WHERE p.account=:account AND p.stream=:stream ORDER BY s.createdAt DESC LIMIT 1";
		
		protected static const GET_OLDEST_STATUS_ID_STATEMENT:String = "SELECT `id` FROM `t_statusPairs` p LEFT JOIN `statuses` s ON p.id=s.id WHERE p.account=:account AND p.stream=:stream ORDER BY s.createdAt ASC LIMIT 1";
		
		protected static const GET_STATUSES_STATEMENT:String = "SELECT s.id, s.createdAt as timestamp, s.text, s.source, s.inReplyToStatusID, s.inReplyToScreenName, s.favorited, u.id as userID, u.name as userFullName, u.screenName as userScreenName, u.icon as userIcon FROM `statuses` s LEFT JOIN `users` u ON s.user=u.id WHERE s.id in (:idList)";
		
		protected static const GET_STREAM_STATUSES_STATEMENT:String = BASE_GET_STREAM_STATUSES_STATEMENT + " WHERE p.account=:account AND p.stream=:stream ORDER BY s.createdAt DESC LIMIT :count";
		
		protected static const GET_STREAM_STATUSES_BEFORE_ID_STATEMENT:String = BASE_GET_STREAM_STATUSES_STATEMENT + " WHERE p.account=:account AND p.stream=:stream AND (length(p.id) < length(:beforeID) OR length(p.id) = length(:beforeID) AND p.id < :beforeID) ORDER BY s.createdAt DESC LIMIT :count";
		
		protected static const GET_NUM_STATUSES_AFTER_ID_STATEMENT:String = "SELECT count(id) as count FROM `t_statusPairs` WHERE account=:account AND stream=:stream AND (length(id) > length(:afterID) OR length(id) = length(:afterID) AND id > :afterID)";
		
		protected static const GET_NUM_SEARCH_STATUSES_AFTER_ID_STATEMENT:String = "SELECT count(id) as count FROM `t_searchStatuses` WHERE account=:account AND (length(id) > length(:afterID) OR length(id) = length(:afterID) AND id > :afterID)";
		
		protected static const GET_STREAM_STATUSES_AFTER_ID_STATEMENT:String = "SELECT * FROM (" + BASE_GET_STREAM_STATUSES_STATEMENT + " WHERE p.account=:account AND p.stream=:stream AND (length(p.id) > length(:afterID) OR length(p.id) = length(:afterID) AND p.id > :afterID) ORDER BY s.createdAt ASC LIMIT :count) ORDER BY timestamp DESC";
		
		protected static const GET_STREAM_STATUSES_SINCE_ID_STATEMENT:String = BASE_GET_STREAM_STATUSES_STATEMENT + " WHERE p.account=:account AND p.stream=:stream AND (length(p.id) > length(:sinceID) OR length(p.id) = length(:sinceID) AND p.id > :sinceID) ORDER BY s.createdAt DESC LIMIT :count";
		
		protected static const UPDATE_STATUS_STATEMENT:String = "INSERT OR IGNORE INTO `statuses` (`user`, `id`, `createdAt`, `text`, `source`, `inReplyToStatusID`, `inReplyToUserID`, `inReplyToScreenName`, `favorited`) " + "VALUES (:user, :id, :createdAt, :text, :source, :inReplyToStatusID, :inReplyToUserID, :inReplyToScreenName, :favorited)";
		
		protected static const UPDATE_SEARCH_STATUS_STATEMENT:String = "INSERT OR IGNORE INTO `t_searchStatuses` (`id`, `account`, `createdAt`, `text`, `source`, `userFullName`, `userScreenName`, `userIcon`) " + "VALUES (:id, :account, :createdAt, :text, :source, :userFullName, :userScreenName, :userIcon)";
		
		protected static const UPDATE_STATUS_PAIR_STATEMENT:String = "INSERT OR IGNORE INTO `t_statusPairs` (`account`, `user`, `id`, `stream`, `list`) " + "VALUES (:account, :user, :id, :stream, :list)";
		
		protected static const UPDATE_STATUS_READ_STATEMENT:String = "INSERT OR IGNORE INTO `t_readStatuses` (`id`) VALUES (:id)";
		
		protected static const GET_NEWEST_INBOX_MESSAGE_ID_STATEMENT:String = "SELECT m.id FROM `t_messages` m LEFT JOIN `t_messagePairs` p ON m.id=p.id WHERE p.account=:account AND p.recipient=:account ORDER BY m.createdAt DESC LIMIT 1";
		
		protected static const GET_OLDEST_INBOX_MESSAGE_ID_STATEMENT:String = "SELECT m.id FROM `t_messages` m LEFT JOIN `t_messagePairs` p ON m.id=p.id WHERE p.account=:account AND p.recipient=:account ORDER BY m.createdAt ASC LIMIT 1";
		
		protected static const GET_NEWEST_SENT_MESSAGE_ID_STATEMENT:String = "SELECT m.id FROM `t_messages` m LEFT JOIN `t_messagePairs` p ON m.id=p.id WHERE p.account=:account AND p.sender=:account ORDER BY m.createdAt DESC LIMIT 1";
		
		protected static const GET_OLDEST_SENT_MESSAGE_ID_STATEMENT:String = "SELECT m.id FROM `t_messages` m LEFT JOIN `t_messagePairs` p ON m.id=p.id WHERE p.account=:account AND p.sender=:account ORDER BY m.createdAt ASC LIMIT 1";
		
		protected static const GET_STREAM_MESSAGES_BEFORE_ID_STATEMENT:String = BASE_GET_STREAM_MESSAGES_STATEMENT + " WHERE p.account=:account AND (p.recipient=:account AND (length(p.id) < length(:beforeInboxID) OR length(p.id) = length(:beforeInboxID) AND p.id < :beforeInboxID) OR p.sender=:account AND (length(p.id) < length(:beforeSentID) OR length(p.id) = length(:beforeSentID) AND p.id < :beforeSentID)) ORDER BY m.createdAt DESC LIMIT :count";
		
		protected static const GET_NUM_MESSAGES_AFTER_ID_STATEMENT:String = "SELECT count(id) as count FROM `t_messagePairs` WHERE account=:account AND length(id) >= length(:afterID) AND id > :afterID";
		
		protected static const GET_STREAM_MESSAGES_AFTER_ID_STATEMENT:String = "SELECT * FROM (" + BASE_GET_STREAM_MESSAGES_STATEMENT + " WHERE p.account=:account AND (p.recipient=:account AND (length(p.id) > length(:afterInboxID) OR length(p.id) = length(:afterInboxID) AND p.id > :afterInboxID) OR p.sender=:account AND (length(p.id) > length(:afterSentID) OR length(p.id) = length(:afterSentID) AND p.id > :afterSentID)) ORDER BY m.createdAt ASC LIMIT :count) ORDER BY timestamp DESC";
		
		protected static const GET_STREAM_MESSAGES_SINCE_ID_STATEMENT:String = BASE_GET_STREAM_MESSAGES_STATEMENT + " WHERE p.account=:account AND (p.recipient=:account AND (length(p.id) > length(:sinceInboxID) OR length(p.id) = length(:sinceInboxID) AND p.id > :sinceInboxID) OR p.sender=:account AND (length(p.id) > length(:sinceSentID) OR length(p.id) = length(:sinceSentID) AND p.id > :sinceSentID)) ORDER BY m.createdAt DESC LIMIT :count";
		
		protected static const UPDATE_MESSAGE_STATEMENT:String = "INSERT OR IGNORE INTO `t_messages` (`sender`, `recipient`, `id`, `createdAt`, `text`) " + "VALUES (:sender, :recipient, :id, :createdAt, :text)";
		
		protected static const UPDATE_MESSAGE_PAIR_STATEMENT:String = "INSERT OR IGNORE INTO `t_messagePairs` (`account`, `sender`, `recipient`, `id`) " + "VALUES (:account, :sender, :recipient, :id)";
		
		protected static const UPDATE_MESSAGE_READ_STATEMENT:String = "INSERT OR IGNORE INTO `t_readMessages` (`id`) VALUES (:id)";
		
		protected static const UPDATE_USER_STATEMENT:String = "REPLACE INTO `users` (`id`, `name`, `screenName`, `location`, `description`, `icon`, `url`, `isProtected`, `followersCount`, `friendsCount`, `createdAt`, `favoritesCount`, `statusesCount`, `listedCount`) " + "VALUES (:id, :name, :screenName, :location, :description, :icon, :url, :isProtected, :followersCount, :friendsCount, :createdAt, :favoritesCount, :statusesCount, :listedCount)";
		
		protected static const UPDATE_USER_ID_STATEMENT:String = "INSERT OR IGNORE INTO `users` (`id`) VALUES (:id)";
		
		protected static const UPDATE_FRIEND_PAIR_STATEMENT:String = "INSERT OR IGNORE INTO `friendPairs` (`account`, `id`) VALUES (:account, :id)";
		
		protected static const GET_FILTERED_FRIEND_LIST_STATEMENT:String = "SELECT u.screenName FROM `friendPairs` p LEFT JOIN `users` u ON p.id=u.id WHERE p.account=:account AND u.screenName LIKE :filter || '%' ESCAPE '!' ORDER BY LOWER(u.screenName) ASC";
		
		protected static const GET_USER_STATEMENT:String = "SELECT * FROM `users` WHERE `screenName` LIKE :screenName LIMIT 1";
		
		protected static const ADD_FRIEND_STATEMENT:String = "INSERT OR IGNORE INTO `friendPairs` (`account`, `id`) VALUES (:account, :id)";
		
		protected static const REMOVE_FRIEND_STATEMENT:String = "DELETE FROM `friendPairs` WHERE `account`=:account AND `id`=:id";
		
        protected var getAccountsStatement:SQLStatement = new SQLStatement();

        protected var getEmptyUsersStatement:SQLStatement = new SQLStatement();

        protected var getFilteredFriendsStatement:SQLStatement = new SQLStatement();

        protected var getFriendsStatement:SQLStatement = new SQLStatement();

        protected var getNewestInboxMessageIDStatement:SQLStatement = new SQLStatement();

        protected var getNewestSentMessageIDStatement:SQLStatement = new SQLStatement();

        protected var getNewestStatusIDStatement:SQLStatement = new SQLStatement();

        protected var getNumMessagesAfterIDStatement:SQLStatement = new SQLStatement();

        protected var getNumStatusesAfterIDStatement:SQLStatement = new SQLStatement();
		
        protected var getNumSearchStatusesAfterIDStatement:SQLStatement = new SQLStatement();

        protected var getOldestInboxMessageIDStatement:SQLStatement = new SQLStatement();

        protected var getOldestSentMessageIDStatement:SQLStatement = new SQLStatement();

        protected var getOldestStatusIDStatement:SQLStatement = new SQLStatement();

        protected var getStatusesStatement:SQLStatement = new SQLStatement();

        protected var getUserStatement:SQLStatement = new SQLStatement();

        //--------------------------------------------------------------------------
        //
        //  Instances
        //
        //--------------------------------------------------------------------------

        protected var syncConnection:SQLConnection = new SQLConnection();

		protected var asyncConnection:SQLConnection = new SQLConnection();

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var sqlRunner:SQLRunner;
		
		protected var statusReadTimer:Timer = new Timer(2000.0, 1);
		
		protected var messageReadQueue:Vector.<Number> = new Vector.<Number>();
		
		protected var messageReadTimer:Timer = new Timer(2000.0, 1);
		
		protected var queueList:Vector.<QueuedCallVO> = new Vector.<QueuedCallVO>();
		
		protected var statusReadQueue:Vector.<String> = new Vector.<String>();

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function DatabaseController()
        {
        }
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function createTables():void
        {
			sqlRunner = new SQLRunner(model.file, 1);
			
			syncConnection.open(model.file);
			asyncConnection.openAsync(model.file);
			
			var batch:Vector.<QueuedStatement> = Vector.<QueuedStatement>
				([
					new QueuedStatement('DROP TABLE IF EXISTS statuses'),
					new QueuedStatement('DROP TABLE IF EXISTS searchStatuses'),
					new QueuedStatement('DROP TABLE IF EXISTS readStatuses'),
					new QueuedStatement('DROP TABLE IF EXISTS messages'),
					new QueuedStatement('DROP TABLE IF EXISTS readMessages'),
					new QueuedStatement('DROP TABLE IF EXISTS statusPairs'),
					new QueuedStatement('DROP TABLE IF EXISTS messagePairs'),
					getQueuedStatement(CREATE_TABLE_STATEMENT,
					{
						table: 'accounts',
						columns:
							'id INTEGER PRIMARY KEY,' +
							'screenName TEXT,' +
							'accessToken TEXT,' +
							'lastUpdated TEXT,' +
							'active INTEGER'
					}),
					getQueuedStatement(CREATE_TABLE_STATEMENT,
					{
						table: 'users',
						columns:
							'id INTEGER PRIMARY KEY,' +
							'name TEXT,' +
							'screenName TEXT,' +
							'location TEXT,' +
							'description TEXT,' +
							'icon TEXT,' +
							'url TEXT,' +
							'isProtected INTEGER,' +
							'followersCount INTEGER,' +
							'friendsCount INTEGER,' +
							'listedCount INTEGER,' +
							'createdAt TEXT,' +
							'favoritesCount INTEGER,' +
							'statusesCount INTEGER'
					}),
					getQueuedStatement(CREATE_TABLE_STATEMENT,
					{
						table: 'statuses',
						columns:
							'id TEXT PRIMARY KEY,' +
							'user INTEGER,' +
							'createdAt REAL,' + // as timestamp
							'text TEXT,' +
							'source TEXT,' +
							'inReplyToStatusID TEXT,' +
							'inReplyToUserID TEXT,' +
							'inReplyToScreenName TEXT,' +
							'favorited INTEGER'
					}),
					getQueuedStatement(CREATE_TABLE_STATEMENT,
					{
						table: 't_searchStatuses',
						columns:
							'id TEXT PRIMARY KEY,' +
							'account REAL,' +
							'createdAt REAL,' +
							'text TEXT,' +
							'source TEXT,' +
							'userFullName TEXT,' +
							'userScreenName TEXT,' +
							'userIcon TEXT'
					}),
					getQueuedStatement(CREATE_UNIQUE_INDEX_STATEMENT,
					{
						index: 'searchStatusesIndex',
						table: 't_searchStatuses',
						columns: 'account, id'
					}),
					getQueuedStatement(CREATE_TABLE_STATEMENT,
					{
						table: 't_readStatuses',
						columns:
							'id TEXT PRIMARY KEY,' +
							'read INTEGER DEFAULT 1'
					}),
					getQueuedStatement(CREATE_TABLE_STATEMENT,
					{
						table: 't_messages',
						columns:
							'id TEXT PRIMARY KEY,' +
							'sender INTEGER,' +
							'recipient INTEGER,' +
							'createdAt REAL,' + // as timestamp
							'text TEXT'
					}),
					getQueuedStatement(CREATE_TABLE_STATEMENT,
					{
						table: 't_readMessages',
						columns:
							'id TEXT PRIMARY KEY,' +
							'read INTEGER DEFAULT 1'
					}),
					getQueuedStatement(CREATE_TABLE_STATEMENT,
					{
						table: 't_statusPairs',
						columns:
							'account INTEGER,' +
							'id TEXT,' +
							'user INTEGER,' +
							'stream INTEGER,' +
							'list INTEGER'
					}),
					getQueuedStatement(CREATE_TABLE_STATEMENT,
					{
						table: 't_messagePairs',
						columns:
							'account INTEGER,' +
							'id TEXT,' +
							'sender INTEGER,' +
							'recipient INTEGER'
					}),
					getQueuedStatement(CREATE_TABLE_STATEMENT,
					{
						table: 'friendPairs',
						columns:
							'account INTEGER,' +
							'id INTEGER'
					}),
					new QueuedStatement("DELETE FROM statuses", null),
					new QueuedStatement("DELETE FROM t_searchStatuses", null),
					new QueuedStatement("DELETE FROM t_messages", null),
					new QueuedStatement("DELETE FROM t_statusPairs", null),
					new QueuedStatement("DELETE FROM t_messagePairs", null),
					new QueuedStatement("DELETE FROM `users` WHERE `id` NOT IN (SELECT `id` FROM `friendPairs`)", null),
					new QueuedStatement("DELETE FROM `t_readStatuses` WHERE `id` NOT IN (SELECT `id` FROM `t_readStatuses` ORDER BY `id` DESC LIMIT 10000)", null),
					new QueuedStatement("DELETE FROM `t_readMessages` WHERE `id` NOT IN (SELECT `id` FROM `t_readMessages` ORDER BY `id` DESC LIMIT 2000)", null),
					getQueuedStatement(CREATE_UNIQUE_INDEX_STATEMENT,
					{
						index: 'statusPairsIndex',
						table: 't_statusPairs',
						columns: 'account, id, user, stream, list'
					}),
					getQueuedStatement(CREATE_UNIQUE_INDEX_STATEMENT,
					{
						index: 'friendPairsIndex',
						table: 'friendPairs',
						columns: 'account, id'
					}),
					getQueuedStatement(CREATE_UNIQUE_INDEX_STATEMENT,
					{
						index: 'messagePairsIndex',
						table: 't_messagePairs',
						columns: 'account, id, sender, recipient'
					})
				]);

			sqlRunner.executeModify(batch, createTablesResultHandler, createTablesErrorHandler);
        }
		
		public function compact():void
		{
			asyncConnection.compact(new Responder(compactResultHandler, compactErrorHandler));
		}
		
		protected function compactResultHandler(result:SQLEvent):void
		{
			trace("result!", result);
			
			model.isReady = true;
		}
		
		protected function compactErrorHandler(error:SQLError):void
		{
			model.isReady = true;
			
			trace(error);
		}
		
		protected function getQueuedStatement(text:String, parameterList:Object):QueuedStatement
		{
			for (var parameter:String in parameterList)
			{
				text = text.replace(':' + parameter, parameterList[parameter]);
			}

			return new QueuedStatement(text);
		}
		
		protected function createTablesResultHandler(resultList:Vector.<SQLResult>):void
		{
			var batch:Vector.<QueuedStatement> = Vector.<QueuedStatement>([
				getQueuedStatement(ADD_COLUMN_STATEMENT,{table: 'users', column: 'listedCount'})
			]);
			
			sqlRunner.executeModify(batch, addColumnResultHandler, addColumnErrorHandler);
		}
		
		protected function createTablesErrorHandler(error:SQLError):void
		{
			trace(error);
		}
		
		protected function addColumnResultHandler(resultList:Vector.<SQLResult>):void
		{
			cleanup();
		}
		
		protected function addColumnErrorHandler(error:SQLError):void
		{
			cleanup();
			
			trace(error);
		}
		
		public function cleanup():void
		{
			compact();
			/*var batch:Vector.<QueuedStatement> = Vector.<QueuedStatement>
				([
					new QueuedStatement("DELETE FROM t_statuses", null),
					new QueuedStatement("DELETE FROM t_searchStatuses", null),
					new QueuedStatement("DELETE FROM t_messages", null),
					new QueuedStatement("DELETE FROM t_statusPairs", null),
					new QueuedStatement("DELETE FROM t_messagePairs", null),
					new QueuedStatement("DELETE FROM `users` WHERE `id` NOT IN (SELECT `id` FROM `friendPairs`)", null),
					new QueuedStatement("DELETE FROM `t_readStatuses` WHERE `id` NOT IN (SELECT `id` FROM `t_readStatuses` ORDER BY `id` DESC LIMIT 10000)", null),
					new QueuedStatement("DELETE FROM `t_readMessages` WHERE `id` NOT IN (SELECT `id` FROM `t_readMessages` ORDER BY `id` DESC LIMIT 2000)", null)
				]);
			
			sqlRunner.executeModify(batch, cleanupResultHandler, cleanupErrorHandler);*/
		}
		
		protected function cleanupResultHandler(resultList:Vector.<SQLResult>):void
		{
			compact();
		}
		
		protected function cleanupErrorHandler(error:SQLError):void
		{
			compact();
			
			trace(error);
		}

        public function deleteStatus(id:String):void
        {
			var batch:Vector.<QueuedStatement> = Vector.<QueuedStatement>
				([
					new QueuedStatement(DELETE_STATUS_STATEMENT, {id: id}),
					new QueuedStatement(DELETE_STATUS_PAIR_STATEMENT, {id: id})
				]);
			
			sqlRunner.executeModify(batch, null, ignoreErrorHandler);
        }
		
		protected function ignoreResultHandler(resultList:Vector.<SQLResult>):void
		{
			
		}
		
		protected function ignoreErrorHandler(error:SQLError):void
		{
			trace("error!", error.details);
		}
		
		public function deleteSearchStatuses(account:AccountModule):void
		{
			var batch:Vector.<QueuedStatement> = Vector.<QueuedStatement>
				([
					new QueuedStatement(DELETE_SEARCH_STATUSES_STATEMENT, {account: account.infoModel.accessToken.id})
				]);
			
			sqlRunner.executeModify(batch, null, ignoreErrorHandler);
		}

        //--------------------------------------------------------------------------
        //
        //  Accounts
        //
        //--------------------------------------------------------------------------

        public function getAccountList():Array
        {
			getAccountsStatement.execute();
			
			var result:SQLResult = getAccountsStatement.getResult();
			
			return (result && result.data) ? result.data : null;
        }
		
        public function getEmptyUserList(limit:int):Array
        {
			getEmptyUsersStatement.parameters[':limit'] = limit;
			getEmptyUsersStatement.execute();
			
			var result:SQLResult = getEmptyUsersStatement.getResult();
			
			return (result && result.data) ? result.data : null;
        }

        public function getFriends(account:AccountModule, filter:String, resultHandler:Function):void
        {
			var statement:String;
			var parameterList:Object = {account: account.infoModel.accessToken.id};
			
			if (filter)
			{
				statement = GET_FILTERED_FRIEND_LIST_STATEMENT;
				
				if (filter.indexOf('_') != -1)
				{
					filter = filter.replace(/\_/g, '!_');
				}
				
				parameterList['filter'] = filter;
			}
			else
			{
				statement = GET_FRIEND_LIST_STATEMENT;
			}
			
			sqlRunner.execute(statement, parameterList, resultHandler, ScreenNameVO);
        }

        //--------------------------------------------------------------------------
        //
        //  Messages
        //
        //--------------------------------------------------------------------------

        public function getNewestInboxMessageID(account:AccountModule):String
        {
			getNewestInboxMessageIDStatement.parameters[':account'] = account.infoModel.accessToken.id;
			getNewestInboxMessageIDStatement.execute();
			
			var result:SQLResult = getNewestInboxMessageIDStatement.getResult();
			
			if (result && result.data && result.data.length == 1)
			{
				return result.data[0].id;
			}
			
			return null;
        }

        public function getNewestSentMessageID(account:AccountModule):String
        {
			getNewestSentMessageIDStatement.parameters[':account'] = account.infoModel.accessToken.id;
			getNewestSentMessageIDStatement.execute();
			
			var result:SQLResult = getNewestSentMessageIDStatement.getResult();
			
			if (result && result.data && result.data.length == 1)
			{
				return result.data[0].id;
			}
			
			return null;
        }

        //--------------------------------------------------------------------------
        //
        //  Statuses
        //
        //--------------------------------------------------------------------------

        public function getNewestStatusID(account:AccountModule, stream:String):Number
        {
            getNewestStatusIDStatement.parameters[':account'] = account.infoModel.accessToken.id;
            getNewestStatusIDStatement.parameters[':stream'] = StreamType.enum[stream];
            getNewestStatusIDStatement.execute();

            var result:SQLResult = getNewestStatusIDStatement.getResult();

            if (result && result.data && result.data.length == 1)
            {
                return result.data[0].id;
            }

            return 0.0;
        }

        public function getNumMessagesAfterID(account:AccountModule, id:String):int
        {
            getNumMessagesAfterIDStatement.parameters[':account'] = account.infoModel.accessToken.id;
            getNumMessagesAfterIDStatement.parameters[':afterID'] = id;
            getNumMessagesAfterIDStatement.execute();

            var result:SQLResult = getNumMessagesAfterIDStatement.getResult();

            return (result && result.data) ? result.data[0].count : 0;
        }

        public function getNumStatusesAfterID(account:AccountModule, stream:String, id:String):int
        {
            getNumStatusesAfterIDStatement.parameters[':account'] = account.infoModel.accessToken.id;
            getNumStatusesAfterIDStatement.parameters[':stream'] = StreamType.enum[stream];
            getNumStatusesAfterIDStatement.parameters[':afterID'] = id || '0';
            getNumStatusesAfterIDStatement.execute();

            var result:SQLResult = getNumStatusesAfterIDStatement.getResult();

            return (result && result.data) ? result.data[0].count : 0;
        }

        public function getOldestInboxMessageID(account:AccountModule):String
        {
            getOldestInboxMessageIDStatement.parameters[':account'] = account.infoModel.accessToken.id;
            getOldestInboxMessageIDStatement.execute();

            var result:SQLResult = getOldestInboxMessageIDStatement.getResult();

            if (result && result.data && result.data.length == 1)
            {
                return result.data[0].id;
            }

            return null;
        }

        public function getOldestSentMessageID(account:AccountModule):String
        {
            getOldestSentMessageIDStatement.parameters[':account'] = account.infoModel.accessToken.id;
            getOldestSentMessageIDStatement.execute();

            var result:SQLResult = getOldestSentMessageIDStatement.getResult();

            if (result && result.data && result.data.length == 1)
            {
                return result.data[0].id;
            }

            return null;
        }

        public function getOldestStatusID(account:AccountModule, stream:String):Number
        {
            getOldestStatusIDStatement.parameters[':account'] = account.infoModel.accessToken.id;
            getOldestStatusIDStatement.parameters[':stream'] = StreamType.enum[stream];
            getOldestStatusIDStatement.execute();

            var result:SQLResult = getOldestStatusIDStatement.getResult();

            if (result && result.data && result.data.length == 1)
            {
                return result.data[0].id;
            }

            return NaN;
        }

        public function getStatuses(account:AccountModule, ... idList:Array):Array
        {
            getStatusesStatement.text = getStatusesStatement.text.replace(':idList', idList);
            getStatusesStatement.execute();
            getStatusesStatement.text = getStatusesStatement.text.replace(idList, ':idList'); // kind of ghetto but it works

            var result:SQLResult = getStatusesStatement.getResult();

            return (result && result.data) ? result.data : [];
        }

        public function getStreamMessages(account:AccountModule, resultHandler:Function, errorHandler:Function):void
        {
			sqlRunner.execute
				(
					GET_STREAM_MESSAGES_STATEMENT, 
					{
						account: account.infoModel.accessToken.id,
						count: account.messagesModel.count
					},
					resultHandler,
					StreamMessageVO,
					errorHandler
				);
        }

        public function getStreamMessagesAfterID(account:AccountModule, inboxID:String, sentID:String, resultHandler:Function, errorHandler:Function):void
        {
			trace("after", inboxID, sentID);
			sqlRunner.execute
				(
					GET_STREAM_MESSAGES_AFTER_ID_STATEMENT, 
					{
						account: account.infoModel.accessToken.id,
						afterInboxID: inboxID || '0',
						afterSentID: sentID || '0',
						count: account.messagesModel.count
					},
					resultHandler,
					StreamMessageVO,
					errorHandler
				);
        }

        public function getStreamMessagesBeforeID(account:AccountModule, inboxID:String, sentID:String, resultHandler:Function, errorHandler:Function):void
        {
			sqlRunner.execute
				(
					GET_STREAM_MESSAGES_BEFORE_ID_STATEMENT, 
					{
						account: account.infoModel.accessToken.id,
						beforeInboxID: inboxID || '0',
						beforeSentID: sentID || '0',
						count: account.messagesModel.count
					},
					resultHandler,
					StreamMessageVO,
					errorHandler
				);
        }

        public function getStreamMessagesSinceID(account:AccountModule, inboxID:String, sentID:String, resultHandler:Function, errorHandler:Function):void
        {
			trace("since", inboxID, sentID);
			sqlRunner.execute
				(
					GET_STREAM_MESSAGES_SINCE_ID_STATEMENT, 
					{
						account: account.infoModel.accessToken.id,
						sinceInboxID: inboxID || '0',
						sinceSentID: sentID || '0',
						count: account.messagesModel.count
					},
					resultHandler,
					StreamMessageVO,
					errorHandler
				);
        }

        public function getStreamStatuses(account:AccountModule, stream:String, resultHandler:Function, errorHandler:Function):void
        {
			sqlRunner.execute
				(
					BASE_GET_STREAM_STATUSES_STATEMENT + " WHERE p.account=:account AND p.stream=:stream " + getStreamFilter(account, stream) + " ORDER BY s.createdAt DESC LIMIT :count", 
					{
						account: account.infoModel.accessToken.id,
						stream: StreamType.enum[stream],
						count: account[stream + 'Model'].count
					},
					resultHandler,
					StreamStatusVO,
					errorHandler
				);
        }

        public function getStreamStatusesAfterID(account:AccountModule, stream:String, id:String, resultHandler:Function, errorHandler:Function):void
        {
			trace("after id", id);
			sqlRunner.execute
				(
					"SELECT * FROM (" + BASE_GET_STREAM_STATUSES_STATEMENT + " WHERE p.account=:account AND p.stream=:stream AND (length(p.id) > length(:afterID) OR length(p.id) = length(:afterID) AND p.id > :afterID) " + getStreamFilter(account, stream) + " ORDER BY s.createdAt ASC LIMIT :count) ORDER BY timestamp DESC", 
					{
						account: account.infoModel.accessToken.id,
						stream: StreamType.enum[stream],
						afterID: id || '0',
						count: account[stream + 'Model'].count
					},
					resultHandler,
					StreamStatusVO,
					errorHandler
				);
        }

        public function getStreamStatusesBeforeID(account:AccountModule, stream:String, id:String, resultHandler:Function, errorHandler:Function):void
        {
			sqlRunner.execute
				(
					BASE_GET_STREAM_STATUSES_STATEMENT + " WHERE p.account=:account AND p.stream=:stream AND (length(p.id) < length(:beforeID) OR length(p.id) = length(:beforeID) AND p.id < :beforeID) " + getStreamFilter(account, stream) + " ORDER BY s.createdAt DESC LIMIT :count", 
					{
						account: account.infoModel.accessToken.id,
						stream: StreamType.enum[stream],
						beforeID: id || '0',
						count: account[stream + 'Model'].count
					},
					resultHandler,
					StreamStatusVO,
					errorHandler
				);
        }

        public function getStreamStatusesSinceID(account:AccountModule, stream:String, id:String, resultHandler:Function, errorHandler:Function):void
        {
			sqlRunner.execute
				(
					BASE_GET_STREAM_STATUSES_STATEMENT + " WHERE p.account=:account AND p.stream=:stream AND (length(p.id) > length(:sinceID) OR length(p.id) = length(:sinceID) AND p.id > :sinceID) " + getStreamFilter(account, stream) + " ORDER BY s.createdAt DESC LIMIT :count",
					{
						account: account.infoModel.accessToken.id,
						stream: StreamType.enum[stream],
						sinceID: id || '0',
						count: account[stream + 'Model'].count
					},
					resultHandler,
					StreamStatusVO,
					errorHandler
				);
        }
		
		//
		
		public function getNumSearchStatusesAfterID(account:AccountModule, id:String):int
		{
			getNumSearchStatusesAfterIDStatement.parameters[':account'] = account.infoModel.accessToken.id;
			getNumSearchStatusesAfterIDStatement.parameters[':afterID'] = id;
			getNumSearchStatusesAfterIDStatement.execute();
			
			var result:SQLResult = getNumSearchStatusesAfterIDStatement.getResult();
			
			return (result && result.data) ? result.data[0].count : 0;
		}
		
		public function getSearchStreamStatuses(account:AccountModule, resultHandler:Function, errorHandler:Function):void
		{
			sqlRunner.execute
				(
					GET_SEARCH_STREAM_STATUSES_STATEMENT,
					{
						account: account.infoModel.accessToken.id,
						count: account.searchModel.count
					},
					resultHandler,
					StreamStatusVO,
					errorHandler
				);
		}
		
		public function getSearchStreamStatusesAfterID(account:AccountModule, id:String, resultHandler:Function, errorHandler:Function):void
		{
			sqlRunner.execute
				(
					GET_SEARCH_STREAM_STATUSES_AFTER_ID_STATEMENT,
					{
						account: account.infoModel.accessToken.id,
						afterID: id || '0',
						count: account.searchModel.count
					},
					resultHandler,
					StreamStatusVO,
					errorHandler
				);
		}
		
		public function getSearchStreamStatusesBeforeID(account:AccountModule, id:String, resultHandler:Function, errorHandler:Function):void
		{
			sqlRunner.execute
				(
					GET_SEARCH_STREAM_STATUSES_BEFORE_ID_STATEMENT,
					{
						account: account.infoModel.accessToken.id,
						beforeID: id || '0',
						count: account.searchModel.count
					},
					resultHandler,
					StreamStatusVO,
					errorHandler
				);
		}
		
		public function getSearchStreamStatusesSinceID(account:AccountModule, id:String, resultHandler:Function, errorHandler:Function):void
		{
			sqlRunner.execute
				(
					GET_SEARCH_STREAM_STATUSES_SINCE_ID_STATEMENT,
					{
						account: account.infoModel.accessToken.id,
						sinceID: id || '0',
						count: account.searchModel.count
					},
					resultHandler,
					StreamStatusVO,
					errorHandler
				);
		}
		
		//

        public function getUser(screenName:String):SQLUserVO
        {
            getUserStatement.parameters[':screenName'] = screenName;
            getUserStatement.execute();

            var result:SQLResult = getUserStatement.getResult();

			return (result && result.data && result.data.length > 0) ? result.data[0] : null;
        }

        //--------------------------------------------------------------------------
        //
        //  Getters / Setters
        //
        //--------------------------------------------------------------------------

        public function queueStatusRead(status:*, resetTimer:Boolean = true):void
        {
            if (status is StreamStatusVO || status is StatusVO)
            {
                statusReadQueue[statusReadQueue.length] = status.id;

                if (resetTimer)
                    resetStatusTimer();
            }
            else if (status is StreamMessageVO)
            {
                messageReadQueue[messageReadQueue.length] = status.id;

                if (resetTimer)
                    resetMessageTimer();
            }
        }

        public function removeAccount(account:AccountModule):void
        {
			sqlRunner.executeModify
				(
					Vector.<QueuedStatement>
						([
							new QueuedStatement(DELETE_ACCOUNT_STATEMENT, {id: account.infoModel.accessToken.id})
						]),
					null,
					ignoreErrorHandler
				);
        }

        public function resetMessageTimer():void
        {
            if (messageReadQueue.length == 0)
                return;

            messageReadTimer.reset();
            messageReadTimer.start();
        }

        public function resetStatusTimer():void
        {
            if (statusReadQueue.length == 0)
                return;

            statusReadTimer.reset();
            statusReadTimer.start();
        }

        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------

        public function setupStatements():void
        {
            getUserStatement.sqlConnection = syncConnection;
            getAccountsStatement.sqlConnection = syncConnection;
            getNewestStatusIDStatement.sqlConnection = syncConnection;
            getOldestStatusIDStatement.sqlConnection = syncConnection;
            getStatusesStatement.sqlConnection = syncConnection;
            getNumStatusesAfterIDStatement.sqlConnection = syncConnection;
            getNumSearchStatusesAfterIDStatement.sqlConnection = syncConnection;
            getNewestInboxMessageIDStatement.sqlConnection = syncConnection;
            getOldestInboxMessageIDStatement.sqlConnection = syncConnection;
            getNewestSentMessageIDStatement.sqlConnection = syncConnection;
            getOldestSentMessageIDStatement.sqlConnection = syncConnection;
            getNumMessagesAfterIDStatement.sqlConnection = syncConnection;
            getEmptyUsersStatement.sqlConnection = syncConnection;
            getFriendsStatement.sqlConnection = syncConnection;
            getFilteredFriendsStatement.sqlConnection = syncConnection;
            getUserStatement.sqlConnection = syncConnection;
			
			getStatusesStatement.itemClass = GeneralStatusVO;
			getUserStatement.itemClass = SQLUserVO;
			getEmptyUsersStatement.itemClass = SQLUserIDVO;
			
			getAccountsStatement.text = GET_ACCOUNT_LIST_STATEMENT;
			getEmptyUsersStatement.text = GET_EMPTY_USER_LIST_STATEMENT;
			getNewestInboxMessageIDStatement.text = GET_NEWEST_INBOX_MESSAGE_ID_STATEMENT;
			getNewestSentMessageIDStatement.text = GET_NEWEST_SENT_MESSAGE_ID_STATEMENT;
			getNewestStatusIDStatement.text = GET_NEWEST_STATUS_ID_STATEMENT;
			getNumMessagesAfterIDStatement.text = GET_NUM_MESSAGES_AFTER_ID_STATEMENT;
			getNumStatusesAfterIDStatement.text = GET_NUM_STATUSES_AFTER_ID_STATEMENT;
			getOldestInboxMessageIDStatement.text = GET_OLDEST_INBOX_MESSAGE_ID_STATEMENT;
			getOldestSentMessageIDStatement.text = GET_OLDEST_SENT_MESSAGE_ID_STATEMENT;
			getOldestStatusIDStatement.text = GET_OLDEST_STATUS_ID_STATEMENT;
			getStatusesStatement.text = GET_STATUSES_STATEMENT;
			getNumSearchStatusesAfterIDStatement.text = GET_NUM_SEARCH_STATUSES_AFTER_ID_STATEMENT;
			getUserStatement.text = GET_USER_STATEMENT;

            statusReadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, statusReadTimerHandler);
            messageReadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, messageReadTimerHandler);
        }

        //--------------------------------------------------------------------------
        //
        //  Users
        //
        //--------------------------------------------------------------------------

		public function updateUsers(userList:Vector.<UserVO>):void
		{
			var batch:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
			
			for each (var user:UserVO in userList)
			{
				batch[batch.length] = new QueuedStatement(UPDATE_USER_STATEMENT, getUserParameterObject(user));
			}
			
			sqlRunner.executeModify(batch, null, ignoreErrorHandler);
		}
		
		public function addFriend(account:AccountModule, id:int):void
		{
			sqlRunner.executeModify
				(
					Vector.<QueuedStatement>
					([
						new QueuedStatement(ADD_FRIEND_STATEMENT, {account: account.infoModel.accessToken.id, id: id})
					]),
					null,
					ignoreErrorHandler
				);
		}
		
		public function removeFriend(account:AccountModule, id:int):void
		{
			sqlRunner.executeModify
				(
					Vector.<QueuedStatement>
					([
						new QueuedStatement(REMOVE_FRIEND_STATEMENT, {account: account.infoModel.accessToken.id, id: id})
					]),
					null,
					ignoreErrorHandler
				);
		}
		
        public function updateAccount(account:AccountModule, active:Boolean):void
        {
			sqlRunner.executeModify
				(
					Vector.<QueuedStatement>
					([
						new QueuedStatement(UPDATE_ACCOUNT_STATEMENT, 
							{
								id: account.infoModel.accessToken.id,
								screenName: account.infoModel.accessToken.screenName,
								accessToken: account.infoModel.accessToken.key + "/" + account.infoModel.accessToken.secret,
								lastUpdated: String(new Date()),
								active: (active) ? 1 : 0
							})
					]),
					null,
					ignoreErrorHandler
				);
        }
		
		protected function getMessageParameterObject(message:DirectMessageVO):Object
		{
			return {
				sender: message.sender.id,
				recipient: message.recipient.id,
				id: message.id,
				createdAt: message.createdAt.time,
				text: message.text
			};
		}
		
		protected function getMessagePairParameterObject(account:AccountModule, message:DirectMessageVO):Object
		{
			return {
				account: account.infoModel.accessToken.id,
				sender: message.sender.id,
				recipient: message.recipient.id,
				id: message.id
			};
		}
		
		protected function getUserParameterObject(user:UserVO):Object
		{
			return {
				id: user.id,
				name: user.name,
				screenName: user.screenName,
				location: user.location,
				description: user.description,
				icon: user.profileImageURL,
				url: user.url,
				isProtected: user.isProtected,
				followersCount: user.followersCount,
				friendsCount: user.friendsCount,
				createdAt: String(user.createdAt),
				favoritesCount: user.favoritesCount,
				listedCount: user.listedCount,
				statusesCount: user.statusesCount
			};
		}
		
        public function updateMessage(account:AccountModule, message:DirectMessageVO):void
        {
			sqlRunner.executeModify
				(
					Vector.<QueuedStatement>
					([
						new QueuedStatement(UPDATE_MESSAGE_STATEMENT, getMessageParameterObject(message)),
						new QueuedStatement(UPDATE_MESSAGE_PAIR_STATEMENT, getMessagePairParameterObject(account, message)),
						new QueuedStatement(UPDATE_USER_STATEMENT, getUserParameterObject(message.sender)),
						new QueuedStatement(UPDATE_USER_STATEMENT, getUserParameterObject(message.recipient))
					]),
					null,
					ignoreErrorHandler
				);
        }

        public function updateMessageList(account:AccountModule, messageList:Vector.<DirectMessageVO>, resultHandler:Function = null):void
        {
			var batch:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
			
			for each (var message:DirectMessageVO in messageList)
			{
				batch[batch.length] = new QueuedStatement(UPDATE_MESSAGE_STATEMENT, getMessageParameterObject(message));
				batch[batch.length] = new QueuedStatement(UPDATE_MESSAGE_PAIR_STATEMENT, getMessagePairParameterObject(account, message));
				batch[batch.length] = new QueuedStatement(UPDATE_USER_STATEMENT, getUserParameterObject(message.sender));
				batch[batch.length] = new QueuedStatement(UPDATE_USER_STATEMENT, getUserParameterObject(message.recipient));
			}
			
			sqlRunner.executeModify(batch, resultHandler, null);
        }

        public function updateMessageReadList():void
        {
			var batch:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
			
			for each (var id:String in messageReadQueue)
			{
				batch[batch.length] = new QueuedStatement(UPDATE_MESSAGE_READ_STATEMENT, {id: id});
			}
			
			sqlRunner.executeModify(batch, null, ignoreErrorHandler);

            messageReadQueue.length = 0;
        }

		protected function getStatusParameterObject(status:StatusVO):Object
		{
			return {
				user: status.user.id,
				id: status.id,
				createdAt: status.createdAt.time,
				text: status.text,
				source: status.source,
				inReplyToStatusID: status.inReplyToStatusID,
				inReplyToUserID: status.inReplyToUserID,
				inReplyToScreenName: status.inReplyToScreenName,
				favorited: status.favorited
			};
		}
		
		protected function getStatusPairParameterObject(account:AccountModule, status:StatusVO, stream:String = null, list:Number = -1):Object
		{
			return {
				account: account.infoModel.accessToken.id,
				user: status.user.id,
				id: status.id,
				stream: StreamType.enum[stream],
				list: list
			};
		}
		
        public function updateStatus(account:AccountModule, status:StatusVO, stream:String = null, list:Number = -1, resultHandler:Function = null):void
        {
			var batch:Vector.<QueuedStatement> = Vector.<QueuedStatement>
				([
					new QueuedStatement(UPDATE_STATUS_STATEMENT, getStatusParameterObject(status)),
					new QueuedStatement(UPDATE_USER_STATEMENT, getUserParameterObject(status.user))
				]);
			
			if (stream) // || list > -1
			{
				batch[batch.length] = new QueuedStatement(UPDATE_STATUS_PAIR_STATEMENT, getStatusPairParameterObject(account, status, stream, list));
			}
			
			sqlRunner.executeModify(batch, resultHandler, ignoreErrorHandler);
        }
		
        public function updateStatusList(account:AccountModule, statusList:Vector.<StatusVO>, stream:String, list:Number = -1, resultHandler:Function = null):void
        {
			var batch:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();

			for each (var status:StatusVO in statusList)
			{
				batch[batch.length] = new QueuedStatement(UPDATE_STATUS_STATEMENT, getStatusParameterObject(status));
				batch[batch.length] = new QueuedStatement(UPDATE_USER_STATEMENT, getUserParameterObject(status.user));
			
				if (stream) batch[batch.length] = new QueuedStatement(UPDATE_STATUS_PAIR_STATEMENT, getStatusPairParameterObject(account, status, stream, list));
			}

			sqlRunner.executeModify(batch, resultHandler, ignoreErrorHandler);
        }
		
		protected function getSearchStatusParameterObject(account:AccountModule, status:SearchStatusVO):Object
		{
			return {
				account: account.infoModel.accessToken.id,
				id: status.id,
				createdAt: status.createdAt.time,
				text: status.text,
				source: status.source,
				userFullName: status.userName,
				userScreenName: status.userScreenName,
				userIcon: status.userProfileImageURL
			}
		}
		
		public function updateSearchStatus(account:AccountModule, status:SearchStatusVO, resultHandler:Function = null):void
		{
			var batch:Vector.<QueuedStatement> = Vector.<QueuedStatement>
				([new QueuedStatement(UPDATE_SEARCH_STATUS_STATEMENT, getSearchStatusParameterObject(account, status))]);
			
			sqlRunner.executeModify(batch, resultHandler, ignoreErrorHandler);
		}
		
		public function updateSearchStatusList(account:AccountModule, statusList:Vector.<SearchStatusVO>, resultHandler:Function = null):void
		{
			var batch:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
			
			for each (var status:SearchStatusVO in statusList)
			{
				batch[batch.length] = new QueuedStatement(UPDATE_SEARCH_STATUS_STATEMENT, getSearchStatusParameterObject(account, status));
			}
			
			sqlRunner.executeModify(batch, resultHandler, ignoreErrorHandler);
		}

        public function updateStatusReadList():void
        {
			var batch:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
			
            for each (var id:Object in statusReadQueue)
            {
				if (id is String)
				{
					batch[batch.length] = new QueuedStatement(UPDATE_STATUS_READ_STATEMENT, {id: id});
				}
            }
			
			sqlRunner.executeModify(batch, null, null);

			signalBus.updatedStatusReadList.dispatch(statusReadQueue);
			
            statusReadQueue.length = 0;
        }

        public function updateUser(user:UserVO, resultHandler:Function):void
        {
			var batch:Vector.<QueuedStatement> = Vector.<QueuedStatement>
				([new QueuedStatement(UPDATE_USER_STATEMENT, getUserParameterObject(user))]);
			
			sqlRunner.executeModify(batch, resultHandler, null);
        }

        public function updateUserIDs(account:AccountModule, idList:Vector.<int>):void
        {
			var batch:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
			
            for each (var id:int in idList)
            {
				batch[batch.length] = new QueuedStatement(UPDATE_USER_ID_STATEMENT, {id: id});
				batch[batch.length] = new QueuedStatement(UPDATE_FRIEND_PAIR_STATEMENT, {account: account.infoModel.accessToken.id, id: id});
            }

			sqlRunner.executeModify(batch, null, null);
        }
		
		protected function updateUserIDsResultHandler(resultList:Vector.<SQLResult>):void
		{
			signalBus.updatedUserIDs.dispatch();
		}

        //--------------------------------------------------------------------------
        //
        //  Handlers
        //
        //--------------------------------------------------------------------------

        protected function getStreamFilter(account:AccountModule, stream:String):String
        {
            var model:BaseAccountStreamModel;
            var filter:String = "";
            var filterPreference:String, filterItem:String;
            var filterItemList:Array;

            switch (stream)
            {
                case StreamType.HOME:
                    if (!preferencesController.getBoolean(PreferenceType.HOME_FILTER))
                        return filter;

                    model = account.homeModel;
                    break;
                case StreamType.MENTIONS:
                    if (!preferencesController.getBoolean(PreferenceType.MENTIONS_FILTER))
                        return filter;

                    model = account.mentionsModel;
                    break;
                case StreamType.SEARCH:
                case StreamType.MESSAGES:
                    return "";
                    break;
            }

            if (model.screenNameFilter && model.screenNameFilter.length > 0)
            {
                filter += " AND LOWER(u.screenName) NOT IN ('" + model.screenNameFilter.join('\',\'').toLowerCase() + "')";
            }

            if (model.keywordFilter && model.keywordFilter.length > 0)
            {
                filterItemList = model.keywordFilter;

                for each (filterItem in filterItemList)
                {
					if (filterItem.indexOf('%') == -1)
					{
						filterItem = "'%" + filterItem + "%'";
					}
					else
					{
						filterItem = "'" + filterItem + "'";
					}
					
                    filter += " AND s.text NOT LIKE " + filterItem;
                }
            }

            if (model.sourceFilter && model.sourceFilter.length > 0)
            {
                filterItemList = model.sourceFilter;

                for each (filterItem in filterItemList)
                {
                    filter += " AND s.source NOT LIKE '%>" + filterItem + "<%'";
                }
            }
			
			if (filter)
			{
				filter = " AND (u.id=" + account.infoModel.accessToken.id + " OR (" + filter.replace(' AND ', '') + "))";
			}

			return filter;
        }

        //--------------------------------------
        // Messages 
        //--------------------------------------

        protected function messageReadTimerHandler(event:TimerEvent):void
        {
            updateMessageReadList();
        }

        //--------------------------------------
        // Statuses 
        //--------------------------------------

        protected function statusReadTimerHandler(event:TimerEvent):void
        {
            updateStatusReadList();
        }
    }
}