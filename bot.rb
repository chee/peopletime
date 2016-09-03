require 'telegram_bot'
require 'sqlite3'

db = SQLite3::Database.new "people.db"

def table_exists?
  true
end

unless table_exists?
  rows = db.execute <<-SQL
    create table people (
      person varchar(255),
      place int
    );
  SQL
end

def set_person_time(person, place)
  db = SQLite3::Database.new "people.db"
  db.execute "insert into people values ( '#{person}', #{place} );"
end

def get_person_time(person)
  db = SQLite3::Database.new "people.db"
  result = db.execute("select place from people where person = '#{person}';")
  if result[0]
    zone = result[0][0]
    time = Time.new
    time = time.getutc
    time += (60 * 60 * zone)
    "#{time.hour}:#{time.min}"
  else
    "unknown"
  end
end

def delete_person(person)
  db = SQLite3::Database.new "people.db"
  db.execute "delete from people where person = '#{person}';"
end

bot = TelegramBot.new(token: '269576788:AAFYdxw9M7YW7e1G-bh5ZRFpPvXBSpJnk2w')

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

  message.reply do |reply|
    case command
    when /(\w+)\s+is\s+in\s+(.*+)/i
      person = $1
      place = $2
      set_person_time(person, place)
      reply.text = "set #{person} to #{place}!"
    when /time\s+in\s+(\w+)/i
      person = $1
      time = get_person_time(person)
      reply.text = "it's #{time} in #{person}"
    when /delete\s+(\w+)/i
      person = $1
      delete_person(person)
      reply.text = "#{person} has been deleted"
    else
      reply.text = "#{message.from.first_name}, i have no idea what #{command.inspect} means."
    end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
