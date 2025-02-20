CREATE TABLE telegram_user (
  user_id INTEGER PRIMARY KEY,
  username varchar(32) unique,
  first_name varchar(30),
  last_name varchar(30)
);

create table account(
  account_id INTEGER PRIMARY KEY references telegram_user(user_id) ON DELETE CASCADE,
  phone_number varchar(15) NOT NULL unique,
  last_seen timestamp NOT NULL,
  bio varchar(70),
  birth_day INTEGER,
  birth_month INTEGER,
  birth_year INTEGER,
  account_type INTEGER
);
  
create table bot(
  bot_id INTEGER PRIMARY KEY references telegram_user(user_id) ON DELETE CASCADE,
  about varchar(40),
  number_of_users INTEGER NOT NULL
);

CREATE TABLE chat (
  chat_id INTEGER PRIMARY KEY, 
  number_of_messages INTEGER NOT NULL,
  chat_type VARCHAR(30) NOT NULL CHECK 
  (chat_type IN ('PV', 'Group', 'Channel'))
);

CREATE TABLE folder(
  folder_id INTEGER PRIMARY KEY,
  account_id INTEGER NOT NULL references account(account_id) ON DELETE CASCADE,
  folder_name VARCHAR(15) NOT NULL
);

CREATE TABLE chat_folder(
  chat_id INTEGER references chat(chat_id) ON DELETE CASCADE,
  folder_id INTEGER references folder(folder_id) ON DELETE CASCADE,
  PRIMARY KEY(chat_id,folder_id)
);

CREATE TABLE user_pv (
  pv_id INTEGER PRIMARY KEY references chat(chat_id) ON DELETE CASCADE,
  user1_id INTEGER NOT NULL references telegram_user(user_id) ON DELETE CASCADE,
  user2_id INTEGER NOT NULL references telegram_user(user_id) ON DELETE CASCADE,
  CHECK (user1_id <> user2_id),
  unique(user1_id,user2_id)
);

CREATE TABLE telegram_group(
  group_id INTEGER PRIMARY KEY references chat(chat_id) ON DELETE CASCADE,
  invite_link varchar(100) NOT NULL unique,
  name varchar(50) NOT NULL,
  is_private boolean NOT NULL,
  number_of_members INTEGER NOT NULL,
  is_history_hidden boolean NOT NULL
);

CREATE TABLE channel(
  channel_id INTEGER PRIMARY KEY references chat(chat_id) ON DELETE CASCADE,
  invite_link varchar(100) NOT NULL unique,
  name varchar(50) NOT NULL,
  is_private boolean NOT NULL,
  number_of_subscribers INTEGER NOT NULL
);

CREATE table channel_discussion(
  channel_id INTEGER PRIMARY KEY references channel(channel_id) ON DELETE CASCADE,
  group_id INTEGER NOT NULL references telegram_group(group_id) ON DELETE CASCADE
);

CREATE table media(
  media_id INTEGER PRIMARY KEY,
  URL varchar(500) NOT NULL unique,
  size INTEGER NOT NULL,
  media_type varchar(15) NOT NULL CHECK (media_type IN (
  'location','document','video','photo','video message',
  'voice','music','gif','sticker','text'))
);

CREATE table message(
  message_id INTEGER PRIMARY KEY,
  chat_id INTEGER NOT NULL references chat(chat_id) ON DELETE CASCADE,
  media_id INTEGER references media(media_id),
  read_status boolean NOT NULL default '0',
  edit_time timestamp
);

CREATE table location(
  location_id INTEGER PRIMARY KEY references media(media_id) ON DELETE CASCADE,
  live_option varchar(30) CHECK (live_option IN (
  'for 15 minutes','for 1 hour','for 8 hours','until I turn it off'))
);

create table document(
  document_id INTEGER PRIMARY KEY references media(media_id) ON DELETE CASCADE,
  document_format varchar(30) NOT NULL,
  name varchar(30) NOT NULL
);

CREATE table video(
  video_id INTEGER PRIMARY KEY references media(media_id) ON DELETE CASCADE,
  caption varchar(500),
  limit_time varchar(30) CHECK (limit_time IN (
  'View Once','3 seconds','10 seconds','Do Not Delete')) 
  default 'Do Not Delete'
);

create table video_message(
  video_message_id INTEGER PRIMARY KEY references media(media_id) ON DELETE CASCADE,
  duration time NOT NULL CHECK(duration < '00:01:00')
);

CREATE table photo(
  photo_id INTEGER PRIMARY KEY references media(media_id) ON DELETE CASCADE,
  caption varchar(500),
  limit_time varchar(30) CHECK (limit_time IN (
  'View Once','3 seconds','10 seconds','Do Not Delete')) 
  default 'Do Not Delete'
);

create table voice(
  voice_id INTEGER PRIMARY KEY references media(media_id) ON DELETE CASCADE,
  duration time NOT NULL
);

create table music(
  music_id INTEGER PRIMARY KEY references media(media_id) ON DELETE CASCADE,
  duration time NOT NULL,
  name varchar(30) NOT NULL
);

create table gif(
  gif_id INTEGER PRIMARY KEY references media(media_id) ON DELETE CASCADE,
  duration time NOT NULL
);

create table text(
  text_id INTEGER PRIMARY KEY references media(media_id) ON DELETE CASCADE,
  length INTEGER NOT NULL
);

CREATE table sticker_pack(
  sticker_pack_id INTEGER PRIMARY KEY,
  name varchar(30) NOT NULL
);

CREATE table sticker(
  sticker_id INTEGER PRIMARY KEY references media(media_id),
  sticker_pack_id INTEGER references sticker_pack(sticker_pack_id) ON DELETE CASCADE
);

CREATE table emoji(
  emoji_id INTEGER PRIMARY KEY references media(media_id) ON DELETE CASCADE,
  category varchar(30) NOT NULL CHECK(category IN (
  'Emoji & People','Animals and nature','Food and drink',
  'Activity','Travel and places','Objects','Symbols','Flags'))
);

CREATE table text_emoji_contain(
  text_id INTEGER references text(text_id) ON DELETE CASCADE,
  emoji_id INTEGER references emoji(emoji_id) ON DELETE CASCADE,
  which_char INTEGER,
  PRIMARY KEY(text_id,emoji_id,which_char)
);

CREATE table sticker_emoji_default(
  sticker_id INTEGER PRIMARY KEY references sticker(sticker_id) ON DELETE CASCADE,
  emoji_id INTEGER NOT NULL references emoji(emoji_id) ON DELETE CASCADE
);

CREATE table account_stickers(
  account_id INTEGER references account(account_id) ON DELETE CASCADE,
  sticker_id INTEGER references sticker(sticker_id) ON DELETE CASCADE,
  number_of_use INTEGER NOT NULL,
  is_favorite boolean NOT NULL default '0',
  is_recent boolean NOT NULL default '0',
  PRIMARY KEY(account_id,sticker_id)
);

CREATE table account_gifs(
  account_id INTEGER references account(account_id) ON DELETE CASCADE,
  gif_id INTEGER references gif(gif_id) ON DELETE CASCADE,
  number_of_use INTEGER NOT NULL,
  is_recent boolean NOT NULL default '0',
  PRIMARY KEY(account_id,gif_id)
);

CREATE table profile_account_has(
  profile_id INTEGER PRIMARY KEY,
  account_id INTEGER NOT NULL references account(account_id) ON DELETE CASCADE,
  set_date Date NOT NULL,
  profile_type varchar(10) NOT NULL CHECK(profile_type IN ('photo' , 'video')),
  URL varchar(500) NOT NULL unique
);

CREATE table profile_chat_has(
  profile_id INTEGER PRIMARY KEY,
  chat_id INTEGER NOT NULL references chat(chat_id) ON DELETE CASCADE,
  set_date Date NOT NULL,
  profile_type varchar(10) NOT NULL CHECK(profile_type IN ('photo' , 'video')),
  URL varchar(500) NOT NULL unique
);

CREATE table account_bot_use(
  account_id INTEGER references account(account_id) ON DELETE CASCADE,
  bot_id INTEGER references bot(bot_id) ON DELETE CASCADE,
  use_date Date NOT NULL,
  PRIMARY KEY(account_id,bot_id)
);

CREATE table ads(
  ads_id INTEGER PRIMARY KEY,
  URL varchar(500) NOT NULL unique
);

create table free_account_ads_view(
  account_id INTEGER references account(account_id) ON DELETE CASCADE,
  ads_id INTEGER references ads(ads_id) ON DELETE CASCADE,
  PRIMARY KEY(account_id,ads_id)
);

create table account_security(
  account_id INTEGER references account(account_id) ON DELETE CASCADE,
  permission_for varchar(20) CHECK (permission_for IN (
  'Phone Number','Last Seen & Online','Profile Photos',
  'Forwarded Messages','Calls','Date of Birth','Gifts',
  'Bio','Invites')),
  permission_level varchar(20) NOT NULL CHECK(permission_level IN (
  'Everybody','My Contact','Nobody')),
  PRIMARY KEY(account_id,permission_for)
);

create table add_to_exception(
  adder_id INTEGER references account(account_id) ON DELETE CASCADE,
  added_id INTEGER references account(account_id) ON DELETE CASCADE,
  exception_for varchar(20) CHECK (exception_for IN (
  'phone number', 'last seen & online', 'profile photos','bio',
  'gifts', 'date of birth', 'forwarded messages', 'calls', 'invites')),
  CHECK (adder_id <> added_id),
  PRIMARY KEY(adder_id,added_id,exception_for)
);

create table session(
  session_id INTEGER PRIMARY KEY,
  account_id INTEGER NOT NULL references account(account_id) ON DELETE CASCADE,
  Last_use_date Date NOT NULL,
  activate_date Date NOT NULL,
  device_name varchar(20) NOT NULL,
  IP_address varchar(20) NOT NULL,
  OS varchar(15) NOT NULL,
  telegram_type varchar(15) NOT NULL
);

create table block(
  account_id INTEGER references account(account_id) ON DELETE CASCADE,
  user_id INTEGER references telegram_user(user_id) ON DELETE CASCADE,
  CHECK (account_id <> user_id),
  PRIMARY KEY(account_id,user_id)
);

create table call(
  account1_id INTEGER references account(account_id) ON DELETE CASCADE,
  account2_id INTEGER references account(account_id) ON DELETE CASCADE,
  call_date Date,
  call_time time,
  status varchar(15) NOT NULL CHECK(status IN (
  'Incoming call','Outgoing call','Missed call','Declines call')),
  duration time,
  call_type varchar(10) NOT NULL CHECK(call_type IN ('Video Call' , 'Voice Call')),
  CHECK (account1_id <> account2_id),
  PRIMARY KEY(account1_id,account2_id,call_date,call_time)
);

create table contact(
  account1_id INTEGER references account(account_id) ON DELETE CASCADE,
  account2_id INTEGER references account(account_id) ON DELETE CASCADE,
  name varchar(30) NOT NULL,
  CHECK (account1_id <> account2_id),
  PRIMARY KEY(account1_id,account2_id)
);

create table free_account_gift(
  account_id INTEGER references account(account_id) ON DELETE CASCADE,
  free_account_id INTEGER references account(account_id) ON DELETE CASCADE,
  gift_date Date,
  duration INTEGER NOT NULL,
  price INTEGER NOT NULL,
  CHECK (account_id <> free_account_id),
  PRIMARY KEY(account_id,free_account_id)
);

CREATE TABLE media_storage_save_in (
    account_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    media_id INTEGER REFERENCES media(media_id) ON DELETE CASCADE,
    size INTEGER NOT NULL,
    type VARCHAR(15) NOT NULL CHECK (type IN ('text', 'sticker', 'gif', 'music',
    'voice', 'video message', 'photo', 'video', 'document', 'location')),
    PRIMARY KEY (account_id, media_id)
);

CREATE TABLE poll (
    poll_id INTEGER PRIMARY KEY,
    message_id INTEGER REFERENCES message(message_id) ON DELETE CASCADE,
    poll_text VARCHAR(200) NOT NULL,
    is_multiple_choice BOOLEAN NOT NULL DEFAULT FALSE,
    is_anonymous BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE poll_options (
    poll_id INTEGER REFERENCES poll(poll_id) ON DELETE CASCADE,
    options VARCHAR(100) NOT NULL,
    PRIMARY KEY (poll_id, options)
);

CREATE TABLE vote (
    account_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    poll_id INT REFERENCES poll(poll_id) ON DELETE CASCADE,
    chosen_options VARCHAR(100),
    PRIMARY KEY (account_id, poll_id, chosen_options)
);

CREATE TABLE story_account_view (
    account_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    story_id INTEGER NOT NULL,
    time TIME NOT NULL,
    PRIMARY KEY (account_id, story_id)
);

CREATE TABLE story_post (
    story_id INTEGER PRIMARY KEY,
    premium_account_id INTEGER NOT NULL REFERENCES account(account_id) ON DELETE CASCADE,
    set_time TIME NOT NULL,
    set_date DATE NOT NULL,
    duration TIME NOT NULL,
    type VARCHAR(10) NOT NULL CHECK (type IN ('photo', 'video')),
    URL VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE user_message_send (
    message_id INTEGER PRIMARY KEY REFERENCES message(message_id) ON DELETE CASCADE,
    user_id INT REFERENCES telegram_user(user_id) ON DELETE CASCADE,
    send_date DATE NOT NULL,
    send_time TIME NOT NULL
);

CREATE TABLE user_message_receive (
    user_id INTEGER REFERENCES telegram_user(user_id) ON DELETE CASCADE,
    message_id INTEGER REFERENCES message(message_id) ON DELETE CASCADE,
    receive_date DATE NOT NULL,
    receive_time TIME NOT NULL,
    PRIMARY KEY (user_id, message_id)
);

CREATE TABLE user_message_seen (
    message_id INTEGER REFERENCES message(message_id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES telegram_user(user_id) ON DELETE CASCADE,
    seen_date DATE NOT NULL,
    seen_time TIME NOT NULL,
    PRIMARY KEY (message_id, user_id)
);

CREATE TABLE channel_account_message_report (
    account_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    channel_id INTEGER REFERENCES channel(channel_id) ON DELETE CASCADE,
    message_id INTEGER REFERENCES message(message_id) ON DELETE CASCADE,
    report_reason VARCHAR(30) CHECK (report_reason IN ('I don’t like it', 'child abuse',
    'violence', 'illegal goods', 'illegal adult content', 'personal data', 'terrorism',
    'scan or spam', 'copyright')),
    report_date DATE NOT NULL,
    PRIMARY KEY (account_id, channel_id, message_id)
);

CREATE TABLE group_account_memberOf (
    account_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    group_id INTEGER REFERENCES telegram_group(group_id) ON DELETE CASCADE,
    role VARCHAR(15) NOT NULL DEFAULT 'normal member' CHECK (role IN ('owner', 'admin', 'normal member')),
    join_date DATE NOT NULL,
    custom_title VARCHAR(20),
    PRIMARY KEY (account_id, group_id)
);

CREATE TABLE channel_account_subscriberOf (
    account_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    channel_id INTEGER REFERENCES channel(channel_id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL DEFAULT 'normal subscriber' CHECK (role IN ('owner', 'admin', 'normal subscriber')),
    join_date DATE NOT NULL,
    PRIMARY KEY (account_id, channel_id)
);

CREATE TABLE bot_channel_memberOf (
    bot_id INTEGER REFERENCES bot(bot_id) ON DELETE CASCADE,
    channel_id INTEGER REFERENCES channel(channel_id) ON DELETE CASCADE,
    delete_messages BOOLEAN NOT NULL DEFAULT FALSE,
    manage_video_chats BOOLEAN NOT NULL DEFAULT FALSE,
    add_new_admins BOOLEAN NOT NULL DEFAULT FALSE,
    ban_users BOOLEAN NOT NULL DEFAULT FALSE,
    invite_users BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (bot_id, channel_id)
);

CREATE TABLE bot_group_memberOf (
    bot_id INTEGER REFERENCES bot(bot_id) ON DELETE CASCADE,
    group_id INTEGER REFERENCES telegram_group(group_id) ON DELETE CASCADE,
    delete_messages BOOLEAN NOT NULL DEFAULT FALSE,
    manage_video_chats BOOLEAN NOT NULL DEFAULT FALSE,
    add_new_admins BOOLEAN NOT NULL DEFAULT FALSE,
    ban_users BOOLEAN NOT NULL DEFAULT FALSE,
    invite_users BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (bot_id, group_id)
);

CREATE TABLE group_account_removeMember (
    remover_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    removed_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    group_id INT REFERENCES telegram_group(group_id) ON DELETE CASCADE,
    remove_date DATE NOT NULL,
    CHECK (remover_id <> removed_id),
    PRIMARY KEY (remover_id, removed_id, group_id)
);

CREATE TABLE channel_account_removeSubscriber (
    remover_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    removed_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    channel_id INTEGER REFERENCES channel(channel_id) ON DELETE CASCADE,
    remove_date DATE NOT NULL,
    CHECK (remover_id <> removed_id),
    PRIMARY KEY (remover_id, removed_id, channel_id)
);

CREATE TABLE message_chat_user_pin (
    message_id INTEGER REFERENCES message(message_id) ON DELETE CASCADE,
    chat_id INTEGER REFERENCES chat(chat_id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES telegram_user(user_id) ON DELETE CASCADE,
    PRIMARY KEY (message_id, chat_id)
);

CREATE TABLE message_reaction_account_make (
    account_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    message_id INTEGER REFERENCES message(message_id) ON DELETE CASCADE,
    reaction_id INTEGER NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    PRIMARY KEY (account_id, message_id)
);

CREATE TABLE account_bot_message_report (
    account_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    bot_id INTEGER REFERENCES bot(bot_id) ON DELETE CASCADE,
    message_id INTEGER REFERENCES message(message_id) ON DELETE CASCADE,
    report_reason VARCHAR(255) NOT NULL,
    report_date TIMESTAMP NOT NULL,
    PRIMARY KEY (account_id, bot_id, message_id, report_reason)
);

CREATE TABLE group_account_message_report(
    account_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    group_id INT REFERENCES telegram_group(group_id) ON DELETE CASCADE,
    message_id INTEGER REFERENCES message(message_id) ON DELETE CASCADE,
    report_reason VARCHAR(30) CHECK (report_reason IN ('I don’t like it', 'child abuse',
    'violence', 'illegal goods', 'illegal adult content', 'personal data', 'terrorism',
    'scan or spam', 'copyright')),
    report_date DATE NOT NULL,
    PRIMARY KEY (account_id, group_id, message_id, report_reason)
);

CREATE TABLE account_message_schedule (
    message_id INTEGER REFERENCES message(message_id) ON DELETE CASCADE,
    account_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    date DATE NOT NULL,
    time TIME NOT NULL,
    PRIMARY KEY (message_id, account_id)
);

CREATE TABLE account_message_chat_reply (
    account_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    message_id INTEGER REFERENCES message(message_id) ON DELETE CASCADE,
    chat_id INTEGER REFERENCES chat(chat_id) ON DELETE CASCADE,
    date DATE,
    time TIME,
    PRIMARY KEY (account_id, message_id, chat_id, date, time)
);

CREATE TABLE account_message_chat_forward (
    account_id INTEGER REFERENCES account(account_id) ON DELETE CASCADE,
    message_id INTEGER REFERENCES message(message_id)ON DELETE CASCADE,
    chat_id INTEGER REFERENCES chat(chat_id) ON DELETE CASCADE,
    date DATE,
    time TIME,
    PRIMARY KEY (account_id, message_id, chat_id, date, time)
);