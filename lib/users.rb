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
    @id = opts["id"]
    @fname = opts["fname"]
    @lname = opts["lname"]
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
        CAST(COUNT(question_likes.id) AS FLOAT) / COUNT(questions.id) AS avg_likes_per_question
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
