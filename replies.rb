require_relative 'questions_database'
require_relative 'replies'
require_relative 'users'
require_relative 'questions'
require_relative 'replies'
class Reply < TableModel

  def self.find_by_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
       replies.author_id = (?);
    SQL
    results.map { |result| Reply.new(result) }
  end

  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
       replies.question_id = (?)
    SQL
    results.map { |result| Reply.new(result) }
  end

  attr_accessor :id, :body, :question_id, :parent_reply_id, :author_id

  def initialize(opts = {})
    @id = opts[:id] || opts['id']
    @body = opts[:body] || opts['body']
    @question_id = opts[:question_id] || opts['question_id']
    @parent_reply_id = opts[:parent_reply_id] || opts['parent_reply_id']
    @author_id = opts[:author_id] || opts['author_id']
  end

  def author
    User.find_by_id(author_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    Reply.find_by_id(parent_reply_id)
  end

  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
       replies.parent_reply_id = (?);
    SQL

    results.map { |result| Reply.new(result) }
  end
end
