# Считает среднее значение из элементов массива. Пример:
# [1, 2, 3].avg => 2
class Array
  def avg
    (self.sum / self.length).round(1)
  end
end
