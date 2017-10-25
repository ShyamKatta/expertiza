# represents each row of a heatgrid-table, which is represented by the vm_question_response class.
class VmQuestionResponseRow
  def initialize(questionText, question_id, weight, question_max_score, seq)
    @questionText = questionText
    @weight = weight

    @question_id = question_id
    @question_seq = seq

    @question_max_score = question_max_score

    @score_row = []

    @countofcomments = 0
  end

  attr_reader :countofcomments

  attr_reader :question_seq

  attr_writer :countofcomments

  attr_reader :questionText

  attr_reader :question_id

  attr_reader :score_row

  attr_reader :weight

  # the question max score is the max score of the questionnaire, except if the question is a true/false, in which case
  # the max score is one.
  def question_max_score
    question = Question.find(self.question_id)
    if question.type == "Checkbox"
      return 1
    elsif question.is_a? ScoredQuestion
      @question_max_score
    else
      "N/A"
    end
  end

  def average_score_for_row
    row_average_score = 0.0
    actual_average_score = 0.0 # added new variable to fix the bug
    @score_row.each do |score|
      if score.score_value.is_a? Numeric
        row_average_score += score.score_value.to_f
        actual_average_score += 1   # counting the # of actual given reviews discarding null 
      end
    end
    #############  addition of if logic #################
    if actual_average_score==0
      row_average_score
    else
      row_average_score/=actual_average_score
    end
    #############   end of aadded logic #################
    #row_average_score /= @score_row.length.to_f      ##commented this as it considers unreviewed scores too.
    row_average_score.round(2)
  end
end
