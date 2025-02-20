-- Check if the account_id already exists as a bot_id in the bot table
CREATE OR REPLACE FUNCTION check_account_insert()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (SELECT 1 FROM bot WHERE bot_id = NEW.account_id) THEN
    RAISE EXCEPTION 'Account ID % already exists as a bot ID in the bot table', NEW.account_id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_account_before_insert
BEFORE INSERT ON account
FOR EACH ROW
EXECUTE FUNCTION check_account_insert();



-- Check if the bot_id already exists as an account_id in the account table
CREATE OR REPLACE FUNCTION check_bot_insert()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (SELECT 1 FROM account WHERE account_id = NEW.bot_id) THEN
    RAISE EXCEPTION 'Bot ID % already exists as an account ID in the account table', NEW.bot_id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_bot_before_insert
BEFORE INSERT ON bot
FOR EACH ROW
EXECUTE FUNCTION check_bot_insert();



--increment number of messages
CREATE OR REPLACE FUNCTION increment_chat_messages()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE chat
    SET number_of_messages = number_of_messages + 1
    WHERE chat_id = (SELECT chat_id FROM message WHERE message_id = NEW.message_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_increment_chat_messages
AFTER INSERT ON user_message_send
FOR EACH ROW
EXECUTE FUNCTION increment_chat_messages();



--member increment
CREATE OR REPLACE FUNCTION increment_group_members() 
RETURNS TRIGGER AS $$
BEGIN
    UPDATE telegram_group
    SET number_of_members = number_of_members + 1
    WHERE group_id = NEW.group_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_increment_group_members
AFTER INSERT ON group_account_memberOf
FOR EACH ROW
EXECUTE FUNCTION increment_group_members();



--subscriber increment
CREATE OR REPLACE FUNCTION increment_channel_subscribers() 
RETURNS TRIGGER AS $$
BEGIN
    UPDATE channel
    SET number_of_subscribers = number_of_subscribers + 1
    WHERE channel_id = NEW.channel_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_increment_channel_subscribers
AFTER INSERT ON channel_account_subscriberOf
FOR EACH ROW
EXECUTE FUNCTION increment_channel_subscribers();



-- Delete the removed account from the group_account_memberOf table
CREATE OR REPLACE FUNCTION remove_member_from_group()
RETURNS TRIGGER AS $$
BEGIN
  DELETE FROM group_account_memberOf
  WHERE account_id = NEW.removed_id
  AND group_id = NEW.group_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_remove_member_from_group
AFTER INSERT ON group_account_removeMember
FOR EACH ROW
EXECUTE FUNCTION remove_member_from_group();



-- Delete the removed account from the channel_account_subscriberOf table
CREATE OR REPLACE FUNCTION remove_subscriber_from_channel()
RETURNS TRIGGER AS $$
BEGIN
  DELETE FROM channel_account_subscriberOf
  WHERE account_id = NEW.removed_id
  AND channel_id = NEW.channel_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_remove_subscriber
AFTER INSERT ON channel_account_removeSubscriber
FOR EACH ROW
EXECUTE FUNCTION remove_subscriber_from_channel();



--check premium account is posting a story
CREATE OR REPLACE FUNCTION check_premium_account()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT account_type FROM account WHERE account_id = NEW.premium_account_id) <> 1 THEN
        RAISE EXCEPTION 'Only premium accounts can post a story';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_check_premium_account
BEFORE INSERT ON story_post
FOR EACH ROW
EXECUTE FUNCTION check_premium_account();



-- Check if free_account_id has account_type 0 (not premium)
-- After insertion, change the account_type of free_account_id to 1 (premium)
CREATE OR REPLACE FUNCTION update_account_type_to_premium()
RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT account_type FROM account WHERE account_id = NEW.free_account_id) <> 0 THEN
    RAISE EXCEPTION 'free_account_id must have account_type = 0 to be eligible for a gift';
  END IF;
  UPDATE account
  SET account_type = 1
  WHERE account_id = NEW.free_account_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER set_account_to_premium_after_gift
AFTER INSERT ON free_account_gift
FOR EACH ROW
EXECUTE FUNCTION update_account_type_to_premium();



-- Check if the media is a sticker
CREATE OR REPLACE FUNCTION update_sticker_usage()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (SELECT 1 FROM sticker WHERE sticker_id = (SELECT media_id FROM message WHERE message_id = NEW.message_id)) THEN
  
    -- If the sticker already exists in the account_stickers table, update the usage count and set is_recent to true
    UPDATE account_stickers
    SET number_of_use = number_of_use + 1,
        is_recent = TRUE
    WHERE account_id = NEW.user_id
    AND sticker_id = (SELECT media_id FROM message WHERE message_id = NEW.message_id);

    -- If the sticker is not in the account_stickers table, insert it with number_of_use = 1 and is_recent = true
    IF NOT FOUND THEN
      INSERT INTO account_stickers (account_id, sticker_id, number_of_use, is_recent)
      VALUES (NEW.user_id, (SELECT media_id FROM message WHERE message_id = NEW.message_id), 1, TRUE)
      ON CONFLICT (account_id, sticker_id) DO NOTHING;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_update_sticker_usage
AFTER INSERT ON user_message_send
FOR EACH ROW
EXECUTE FUNCTION update_sticker_usage();



 -- Check if the message contains a GIF
CREATE OR REPLACE FUNCTION update_gif_usage()
RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT media_type FROM media WHERE media_id = NEW.media_id) = 'gif' THEN

    -- If the GIF is already in the account_gifs table, increment number_of_use and set is_recent to true
    UPDATE account_gifs
    SET number_of_use = number_of_use + 1, is_recent = TRUE
    WHERE account_id = NEW.user_id AND gif_id = NEW.media_id;

    -- If the GIF is not in the account_gifs table, insert a new record with number_of_use = 1 and is_recent = true
    IF NOT FOUND THEN
      INSERT INTO account_gifs (account_id, gif_id, number_of_use, is_recent)
      VALUES (NEW.user_id, NEW.media_id, 1, TRUE);
    END IF;

  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_update_gif_usage
AFTER INSERT ON user_message_send
FOR EACH ROW
EXECUTE FUNCTION update_gif_usage();