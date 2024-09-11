# create restaurant.db using R
library(DBI)
library(RSQLite)

# create the pizza_menu table
pizza_id <- 1:10
pizza_menu <- c("The Classic", "The Meat Lovers", "The Veggie Supreme", 
          "The Hawaiian Delight", "The White Pizza (Bianco)",
          "Spicy Diablo", "The BBQ Chicken", "The Seafood Extravaganza",
          "The Vegetarian Pesto", "The Gourmet Goat Cheese")
pizza_price_thb <- c(220, 280, 250, 240, 260, 270, 290, 320, 280, 300)

pizza_df <- data.frame(
  id = pizza_id,
  item = pizza_menu,
  price_thb = pizza_price_thb,
  type = rep("Pizza", length(pizza_id))
)

# create drink_menu table
drink_id <- 11:14
drink_menu <- c("Coke", "Water", "Coffee", "Tea")
drink_price_thb <- c(35, 20, 80, 65)


drink_df <- data.frame(
  id = drink_id,
  item = drink_menu,
  price_thb = drink_price_thb,
  type = rep("Drink", length(drink_id))
)

menu <- rbind(pizza_df, drink_df)

# create customer table
customer_id <- 1:5
customer_name <- c("Alice", "Bob", "Charlie", "David", "Eve")
customers_df <- data.frame(customer_id, customer_name)

# create transaction table as starting point
drop_table_if_exists <- function(con, table_name) {
  query <- paste0("DROP TABLE IF EXISTS ", table_name, ";")
  dbExecute(con, query)
  print(paste0("Table", table_name, "dropped if it existed."))
}




## create database using RSQLite

con <- dbConnect(RSQLite::SQLite(), dbname = "restaurant.db")

drop_table_if_exists(con, "transactions")
drop_table_if_exists(con, "transaction_items")
drop_table_if_exists(con, "customers")


dbExecute(con,
          "CREATE TABLE IF NOT EXIST transactions (
         transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,
         customer_id INTEGER,
         order_time TEXT,
         FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
         );")

dbExecute(con,
          "CREATE TABLE IF NOT EXISTS transaction_items 
          (
            item_id INTEGER PRIMARY AUTOINCREMENT,
            transaction_id INTEGER,
            item TEXT,
            quantity INTEGER,
            price_tab REAL,
            FOREIGN KEY(transaction_id) REFERENCES transactions(transaction_id)
          );
")

dbExecute(con,
          "CREATE TABLE IF NOT EXISTS customers 
          (
            customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            phone TEXT
          )")


dbWriteTable(con, "customers", customers_df, overwrite = TRUE, row.names= FALSE)
dbWriteTable(con, "menu", menu, overwrite = TRUE, row.names = FALSE)


# read and print
customers_result <- dbReadTable(con, "customers")
transaction_result <- dbReadTable(con, "transactions")
menu_result <- dbReadTable(con, "menu")
print(customers_result)

# close the connection
dbDisconnect(con)
