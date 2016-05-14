require_relative 'questions_database'
require_relative 'users'
require_relative 'questions'

class QuestionFollow < TableModel

  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_follows
      JOIN
        users on question_follows.user_id = users.id
      WHERE
        question_follows.question_id = (?);
    SQL

    results.map { |result| User.new(result) }
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_follows
      JOIN
        questions on question_follows.question_id = questions.id
      WHERE
        question_follows.user_id = (?);
    SQL

    results.map { |result| Question.new(result) }
  end

  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL ,n)
      SELECT
        questions.*
      FROM
        questions
      LEFT OUTER JOIN
        question_follows
      ON
        questions.id = question_follows.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_follows.id) DESC
      LIMIT (?)
    SQL
    results.map { |result| Question.new(result) }
  end


  attr_accessor :id, :question_id, :user_id

  def initialize(opts = {})
    @id = opts["id"]
    @question_id = opts["question_id"]
    @user_id = opts["user_id"]
  end
end

if __FILE__ == $PROGRAM_NAME

end
