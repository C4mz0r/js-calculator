require 'rubygems'
require 'selenium-webdriver'

browser = Selenium::WebDriver.for :firefox
index = File.expand_path("index.html", Dir.pwd)
browser.get "file://#{index}"
wait = Selenium::WebDriver::Wait.new(:timeout => 15)


# Unit-style tests

describe "Addition" do
  it "should add two numbers" do
    expect(browser.execute_script("return add(1,2)")).to eq(3)
    expect(browser.execute_script("return add(-10,10)")).to eq(0)
    expect(browser.execute_script("return add(-1,-2)")).to eq(-3)
  end
end

describe "Subtraction" do
  it "should subtract two numbers" do
    expect(browser.execute_script("return subtract(0,2)")).to eq(-2)
    expect(browser.execute_script("return subtract(10,10)")).to eq(0)
    expect(browser.execute_script("return subtract(-1,-2)")).to eq(1)
  end  
end

describe "Multiplication" do
  it "should multiply two numbers" do
    expect(browser.execute_script("return multiply(0,2)")).to eq(0)
    expect(browser.execute_script("return multiply(10,10)")).to eq(100)
    expect(browser.execute_script("return multiply(-1,-2)")).to eq(2)
  end  
end

describe "Division" do
  it "should divide two numbers" do
    expect(browser.execute_script("return divide(0,2)")).to eq(0)
    expect(browser.execute_script("return divide(10,10)")).to eq(1)
    expect(browser.execute_script("return divide(-1,-2)")).to eq(0.5)
    expect(browser.execute_script("return divide(1,0)")).to eq(nil)
  end  
end

# Integration-style tests
describe "UI Tests" do
  
  before(:each) do
    browser.find_element(:id, "clear").click
  end
  
  describe "Numbers" do
    it "should display 1, 2, ..., 9, 0 on the screen" do
      browser.find_element(:id, "num1").click
      browser.find_element(:id, "num2").click
      browser.find_element(:id, "num3").click
      browser.find_element(:id, "num4").click
      browser.find_element(:id, "num5").click
      browser.find_element(:id, "num6").click
      browser.find_element(:id, "num7").click
      browser.find_element(:id, "num8").click
      browser.find_element(:id, "num9").click
      browser.find_element(:id, "num0").click
      expect(browser.find_element(:class, "screen" ).text).to eq("1234567890") 
    end
  end
  
  describe "Clear" do
    it "should clear the display" do
      browser.find_element(:id, "num0").click # ensure something is on the screen
      expect(browser.find_element(:class, "screen" ).text).not_to eq("")
      browser.find_element(:id, "clear").click
      expect(browser.find_element(:class, "screen" ).text).to eq("") 
    end
  end
  
  describe "Addition button" do
    it "should add 2 numbers" do
      # 12 + 34 = 46
      browser.find_element(:id, "num1").click
      browser.find_element(:id, "num2").click
      browser.find_element(:id, "add").click
      browser.find_element(:id, "num3").click
      browser.find_element(:id, "num4").click
      browser.find_element(:id, "equal").click
      expect(browser.find_element(:class, "screen").text).to eq("46")
    end
  end
  
  describe "Subtraction button" do
    it "should subtract 2 numbers" do
      # 12 - 34 = -22
      browser.find_element(:id, "num1").click
      browser.find_element(:id, "num2").click
      browser.find_element(:id, "subtract").click
      browser.find_element(:id, "num3").click
      browser.find_element(:id, "num4").click
      browser.find_element(:id, "equal").click
      expect(browser.find_element(:class, "screen").text).to eq("-22")
    end
  end
  
  describe "Multiplication button" do
    it "should multiply 2 numbers" do
      # 12 * 34 = 408
      browser.find_element(:id, "num1").click
      browser.find_element(:id, "num2").click
      browser.find_element(:id, "multiply").click
      browser.find_element(:id, "num3").click
      browser.find_element(:id, "num4").click
      browser.find_element(:id, "equal").click
      expect(browser.find_element(:class, "screen").text).to eq("408")
    end
  end
  
  describe "Divide button" do
    it "should divide 2 numbers to give a fraction" do
      # 12 / 34 = 0.35294117647058826
      browser.find_element(:id, "num1").click
      browser.find_element(:id, "num2").click
      browser.find_element(:id, "divide").click
      browser.find_element(:id, "num3").click
      browser.find_element(:id, "num4").click
      browser.find_element(:id, "equal").click
      expect(browser.find_element(:class, "screen").text).to eq("0.35294117647058826")
    end
    
    it "should show infinity during division by zero" do
      browser.find_element(:id, "num1").click
      browser.find_element(:id, "num2").click
      browser.find_element(:id, "divide").click
      browser.find_element(:id, "num0").click      
      browser.find_element(:id, "equal").click
      expect(browser.find_element(:class, "screen").text).to eq("Infinity")
    end
  end
  
  describe "Operators" do 
    # 1 + 2 (+) will make it show 3
    # 3 (-) will make it show 6
    # 10 (*) will make it show -4
    # 3 (/) will make it show -12
    # 2 (equal) will make it show -6
    it "should calculate the current result each time the next operator is pressed" do
      browser.find_element(:id, "num1").click
      browser.find_element(:id, "add").click
      browser.find_element(:id, "num2").click
      browser.find_element(:id, "add").click
      expect(browser.find_element(:class, "screen").text).to eq("3")
      
      browser.find_element(:id, "num3").click      
      browser.find_element(:id, "subtract").click
      expect(browser.find_element(:class, "screen").text).to eq("6")
      
      browser.find_element(:id, "num1").click
      browser.find_element(:id, "num0").click
      browser.find_element(:id, "multiply").click
      expect(browser.find_element(:class, "screen").text).to eq("-4")
      
      browser.find_element(:id, "num3").click
      browser.find_element(:id, "divide").click
      expect(browser.find_element(:class, "screen").text).to eq("-12")
      
      browser.find_element(:id, "num2").click
      browser.find_element(:id, "equal").click
      expect(browser.find_element(:class, "screen").text).to eq("-6")            
    end
    
    it "should allow the user to update the operator that they have just pressed" do
      # user entered the first number then +, but decided they wanted to multiply instead of add,
      # so then pressed * and then entered the second number.
      # So the output should be 5 * 2 (not 5 + 2)
      browser.find_element(:id, "num5").click
      browser.find_element(:id, "add").click
      browser.find_element(:id, "multiply").click
      browser.find_element(:id, "num2").click    
      browser.find_element(:id, "equal").click  
      expect(browser.find_element(:class, "screen").text).to eq("10")           
    end  
  end
  
  describe "Equal" do
    it "should cause the current equation to be calculated" do
      browser.find_element(:id, "num1").click
      browser.find_element(:id, "add").click
      browser.find_element(:id, "num2").click
      browser.find_element(:id, "equal").click
      expect(browser.find_element(:class, "screen").text).to eq("3")
    end   
  end
    
end