require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')

    self.results_as_hash = true
    self.type_translation = true
  end
end










if __FILE__ == $PROGRAM_NAME


  #p User.find_by_id(1)
  # saveuser = User.new
  # saveuser.fname = 'Breakfast'
  # saveuser.lname= "at Tiffany's"
  # saveuser.save
  #
  # id = User.find_by_name('Breakfast',"at Tiffany's").first.id
  # p id
  # saveuser.lname = 'Club'
  # saveuser.save
  # p User.find_by_id(id)
  savereply = Reply.new
  savereply.body = "Please save me"
  savereply.question_id = 2
  savereply.author_id = 1

  reply_id = savereply.save
  # p savereply

  savereply.body = "I haz been saved?"
  savereply.save
  # p Reply.find_by_id(1)



end
