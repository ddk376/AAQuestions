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
    @id = opts[:id] || opts['id']
    @title = opts[:title] || opts['title']
    @body = opts[:body] || opts['body']
    @author_id = opts[:author_id] || opts['author_id']
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
end


if __FILE__ == $PROGRAM_NAME
  # p Question.where("id = ?", 1 )
  # p Question.where(id: 1, body: 'What day is today?')
  # p Question.find_by_body('What day is today?')
  # q = Question.new(title: "howdy", body: "what's up", author_id: 1)
  # q.save
  r = Question.new({"title" => "wow", "body" => "jslkfjlds", "author_id" => 2})
  r.save
  r.body = "changed body"
  r.save
  r.title = "New title"
  r.save
  p r.title
end
