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
