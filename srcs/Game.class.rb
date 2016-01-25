class Game
  @@allClasses = ["Paladin", "Rogue", "Priest", "Warrior",
                  "Warlock", "Mage", "Druid", "Hunter"]

  def initialize(classname, mycards)
    while !(@@allClasses.include? classname)
      classname  = gets.chomp
    end
    @classname = classname
    @mycards = mycards
  end

  def classname
    @classname
  end

  def mycards
    @mycards
  end
  
  def start()
    puts "A game is beginning."
    loop do
      puts " What is your enemy class ?"
      enemyclass  = gets.chomp
      break if (@@allClasses.include? enemyclass)
    end
    
  end


  
end
