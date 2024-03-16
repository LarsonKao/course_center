# README

* Ruby version 3.2.2

* Docker Usage
  1. cmd enter foler base
  2. run `docker-compose up -d`
    這部分會將db與app建立起來
  4. run `docker exec -t course_center rails db:migrate`
    db schema初始化
  5. run `docker exec -t course_center rails db:seed`
    db seed產生oauth2所需的test applications
  6. have fun.
    參考[docment](openapi_doc.yaml)進行測試
  
* Oauth2 Usage
  Test Application:
  ```
  {
    "name" : "test_client",
    "uid" : "11rD_NPUo9D15hrTuFfgege3iAabZn9gfgnBlEw2", #即參數的client_id
    "secret" : "tSeKtHSQ5x3JJgE57QNHrAjL2Tcy0UdjitxLi33ITQA" #即參數的client_secret
  }
  ```

* DB Schema
  [OnlineGraph](https://dbdiagram.io/d/65f52456ae072629ce2707d0)

* Unit Test
 [folder](/spec/controllers)

* 如果有任何疑問都歡迎與我聯繫。
* Thank You 