require_relative 'model_base'
require_relative 'questions_database'
require_relative 'users'
require_relative 'question_likes'
require_relative 'question_follows'
require_relative 'replies'

class Question < TableModel
  def self.find_by_author_id(author_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.author_id = (?);
    SQL

    results.map! { |result| Question.new(result) }
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  attr_accessor :id, :title, :body, :author_id

  def initialize(opts = {})
    @id = opts["id"]
    @title = opts["title"]
    @body = opts["body"]
    @author_id = opts["author_id"]
  end

  def author
    User.find_by_id(author_id)
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def followers
    QuestionFollow.followers_for_question_id(id)
  end

  def likers
    QuestionLike.likers_for_question_id(id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end

  def save
    if id.nil?
     QuestionsDatabase.instance.execute(<<-SQL, title, body, author_id)
       INSERT INTO
        questions(title, body, author_id)
       VALUES
        (?,?,?)
       SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL,title, body, author_id, id)
       UPDATE
         questions
       SET
         title = (?),
         body = (?),
         author_id = (?)
       WHERE
         id = (?)
       SQL
    end
  end


end


if __FILE__ == $PROGRAM_NAME
  p Question.where("id = ?", 1 )
end
