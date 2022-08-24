require 'csv'
require 'colorize'

class WeatherMan
  ##
  # Read data from shell and store in instance variables
  ##
  def initialize
    @year = ARGV[1]
    @mode = ARGV[0]
    file_path = ARGV[2]
    path_array = file_path.split('/')
    @path = path_array[-1]
    @months = {1 => :Jan, 2 => :Feb, 3 => :Mar, 4 => :Apr, 5 => :May, 6 => :Jun, 7 => :Jul,8 => :Aug,9 => :Sep,10 => :Oct, 11 => :Nov, 12 => :Dec}
  end

  ##
  # generate all file paths from given folder
  ##

  def create_path_year
    @files_name = {}
    i = 0
    @months.each do |keys,values|
      @files_name[i] = "#{@path}/#{@path}_#{@year}_#{values}.csv"
      i = i + 1
    end
    return @files_name
  end

  ##
  # generate path of one file specilly for the months
  ##

  def create_path_month
    year = @year.split('/')
    "#{@path}/#{@path}_#{year[0]}_#{@months[year[1].to_i]}.csv"
  end

  ##
  # Take file name
  # Read specific file
  # return file data
  ##

  def read_files(file_name)
    data = CSV.read(file_name)
    return data
  end

  ##
  # display year result in specific format
  ##

  def display_results
    days = calculate_days
    puts "Highest: #{@high}C on #{@months[days[0].to_i]} #{days[1]}"
    puts "Lowest: #{@low}C on #{@months[days[2].to_i]} #{days[3]}"
    puts "Humid: #{@avg}% on #{@months[days[4].to_i]} #{days[5]}"
  end

  ##
  # display one month results in specific formate
  ##
  def display_month_results
    puts "Highest Average: #{@high}C"
    puts "Lowest Average: #{@low}C"
    puts "Average Humidity: #{@avg}%"
  end

  ##
  # Take day , max temperature, low temperature
  # print '+'  to the respactive max and low
  ##

  def display_graph(day,max,low)
      print "#{day} :"
      max.times do
        print "+".red
      end
      print "  #{max}C\n"

      print "#{day} :"
      low.times do
        print "+".blue
      end
      print "  #{low}C\n"
  end

  ##
  # Take day , max temperature, low temperature
  # print '+'  to the respactive max and low in a single row
  ##

  def display_graph_bonus(day,max,low)
    print "#{day} :"
    low.times do
      print "+".blue
    end

    max.times do
      print "+".red
    end
    print "  #{low}C - #{max}C\n"
  end

  ##
  # Calculate days for years problems
  ##

  def calculate_days
    high = @high_day.split('-')
    low = @low_day.split('-')
    avg = @avg_day.split('-')
    return high[1],high[2],low[1],low[2],avg[1],avg[2]
  end

  ##
  # calculate year max temperature, min temperature, humidity
  ##

  def calculate_year
    files_name = create_path_year
    @high = 0;
    @low = 100;
    @avg = 0;
    @high_day
    @low_day
    @avg_day
    files_name.each do |file|
      data = read_files(file[1])
      data.each do |a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w|
        if @high < b.to_i
          @high = b.to_i
          @high_day = a
        end
        if @low > d.to_i && d.to_i != 0
          @low = d.to_i
          @low_day = a
        end
        if @avg < h.to_i && h.to_i != 0
          @avg = h.to_i
          @avg_day = a
        end
      end
    end
    display_results
  end

  ##
  # calculate month max temperature average, min temperature average and humidity average
  ##

  def calculate_month
    file_name = create_path_month
    @high = 0;
    @low = 100;
    @avg = 0;
    data = read_files(file_name)
    data.each do |a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w|
      @high += b.to_i
      @low += d.to_i
      @avg += h.to_i
    end
    @high /= data.length
    @low /= data.length
    @avg /= data.length
    display_month_results
  end

  ##
  # calculate month max temperature , min temperature  and humidity par day
  ##

  def calculate_month_draw
    file_name = create_path_month
    data = read_files(file_name)
    index = 0
    data.each do |a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w|
      if index > 1
        day = a.split('-')
        display_graph(day[2],b.to_i,d.to_i)
        # display_graph_bonus(day[2],b.to_i,d.to_i)
      end
      index += 1
    end
  end

  ##
  # check mode and send to the relative methods
  ##

  def check_mode
    if @mode == '-e'
      calculate_year
    elsif @mode == '-a'
      calculate_month
    elsif @mode == '-c'
      calculate_month_draw
    else
      puts "Incorrect mode"
    end
  end
end


obj = WeatherMan.new
obj.check_mode
