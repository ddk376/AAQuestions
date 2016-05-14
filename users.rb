require_relative 'model_base'
require_relative 'questions'
require_relative 'replies'
require_relative 'question_follows'
require_relative 'question_likes'

class User < TableModel
  def self.find_by_name(fname, lname)
    results = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
       users.fname = (?) AND users.lname = (?)
    SQL
    results.map { |result| User.new(result) }
  end

  attr_accessor :id, :fname, :lname

  def initialize(opts = {})
    @id = opts[:id] || opts['id']
    @fname = opts[:fname] || opts['fname']
    @lname = opts[:lname] || opts['lname']
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def average_karma
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        CAST(COUNT(question_likes.id) AS FLOAT) / COUNT(DISTINCT(questions.id)) AS avg_likes_per_question
      FROM
        questions
      LEFT OUTER JOIN
        question_likes
      ON
        questions.id = question_likes.question_id
      WHERE
       questions.author_id = (?)
      GROUP BY
        questions.id
    SQL

    results.first['avg_likes_per_question']
  end

  def save
    if id.nil?
     QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
       INSERT INTO
        users(fname, lname)
       VALUES
        (?,?)
       SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL,fname, lname, id)
       UPDATE
         users
       SET
         fname = (?),
         lname = (?)
       WHERE
         id = (?)
       SQL
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  p User.find_by_id(1)
  saveuser = User.new
  saveuser.fname = 'Breakfast'
  saveuser.lname= "at Tiffany's"
  saveuser.save

  id = User.find_by_name('Breakfast',"at Tiffany's").first.id
  p id
  saveuser.lname = 'Club'
  saveuser.save
  p User.find_by_id(id)
end
