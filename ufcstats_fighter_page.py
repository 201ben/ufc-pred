from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
# gives us access to keyboard keys
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains

import pandas as pd
import time


driver = webdriver.Chrome()
#driver.get("http://ufcstats.com/statistics/fighters?char=a&page=all")
wait = WebDriverWait(driver,10)
data = []
for letter in range(ord('a'), ord('z') + 1):
    my_letter = chr(letter)

    print(my_letter)
    driver.get(f"http://ufcstats.com/statistics/fighters?char={my_letter}&page=all")

    table = driver.find_element(By.XPATH,"//table")
    rows = table.find_elements(By.TAG_NAME,"tr")
    #print(rows)
    #pd.read_html(html_table)
    #data.shape[0]
    length = len(rows)
    print(length)
    for i in range (2,length):
        the_path = f"/html/body/section/div/div/div/table/tbody/tr[{i}]/td[2]/a"

        #w = driver.find_element(By.XPATH, f"/html/body/section/div/div/div/table/tbody/tr[{i}]/td[8]")
        #l = driver.find_element(By.XPATH, f"/html/body/section/div/div/div/table/tbody/tr[{i}]/td[9]")
        #d = driver.find_element(By.XPATH, f"/html/body/section/div/div/div/table/tbody/tr[{i}]/td[10]")

        element = wait.until(EC.presence_of_element_located((By.XPATH, the_path)))
        element.click()


        name = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "b-content__title-highlight")))
        height = driver.find_element(By.XPATH, "/html/body/section/div/div/div[1]/ul/li[1]")
        record = driver.find_element(By.XPATH, "/html/body/section/div/h2/span[2]")
        reach = driver.find_element(By.XPATH, " /html/body/section/div/div/div[1]/ul/li[3]")
        stance = driver.find_element(By.XPATH, "/html/body/section/div/div/div[1]/ul/li[4]")
        weight = driver.find_element(By.XPATH, "/html/body/section/div/div/div[1]/ul/li[2]")
        DOB = driver.find_element(By.XPATH, " /html/body/section/div/div/div[1]/ul/li[5]")


     

        #clean up

     

        DOB_f = DOB.text.replace("DOB: ","")
        fighter = [name.text, weight.text, DOB_f, height.text, reach.text, stance.text, record.text]

        data.append(fighter)
        driver.back()

 

 

 

column_name = ["name","weight","DOB", "height", "reach","stance","record"]

df = pd.DataFrame(data, columns=column_name)

print(df)

df.to_csv(r'C:\Users\jihun\wbatlas\data.csv')

#gives me 10seconds

time.sleep(10)