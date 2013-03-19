require 'debugger'
class Employee
  attr_accessor :name, :title, :salary, :boss, :bonus

  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
  end

  def calculate_bonus(multiplier)
    @bonus = @salary * multiplier
  end
end

class Manager < Employee
  attr_accessor :employees
  def initialize(name, title, salary)
    super(name, title, salary)
    @employees = []
  end

  def add_employee(employee)
    @employees << employee
    employee.boss = self
  end

  def calculate_bonus(multiplier)
    total_salaries = 0
    self.collect_employees.each do |employee|
      total_salaries += employee.salary
    end

    @bonus = total_salaries * multiplier
  end

  def collect_employees
    all_employees = []
    queue = [self]

    while queue.count > 0
      #debugger
      current_employee = queue.shift
      unless current_employee.class == Employee
        all_employees += current_employee.employees
        queue += current_employee.employees
      end
    end

    all_employees
  end
end

e1 = Employee.new('worker guy', 'slave', 100)
e2 = Employee.new('worker guy2', 'slave', 200)
e3 = Manager.new('worker guy3', 'slave', 300)
boss = Manager.new('Bob', "manager", 1000000)

e3.add_employee(e1)
boss.add_employee(e2)
boss.add_employee(e3)


p boss.calculate_bonus(0.10)

#p boss.employees[0].name
#p e1.boss.name


