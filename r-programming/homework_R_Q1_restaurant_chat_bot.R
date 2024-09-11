## homework 1
## homework
## 1.chatbot order pizza
library(DBI)
library(RSQLite)
library(dplyr)
con <- dbConnect(RSQLite::SQLite(), dbname = "restaurant.db")
pizza_menu <- dbReadTable(con, "menu")
customers <- dbReadTable(con, "customers")

pizza <- pizza_menu %>%
  filter(type == "Pizza") %>%
  select(id, item, price_thb)
  
  
drink <- pizza_menu %>%
  filter(type == "Drink") %>%
  select(id, item, price_thb)


pizza_order <- function() {
  items <- character()
  quantities <- integer()
  print("Here is our pizza menu! 📕")
  print(pizza)
  repeat {
    no <- readline("Please select pizza no (1 to 10) to order (or 'done' to finish): ")

    if(tolower(no) == "done") {
      break
    }
    
    while (!no %in% pizza$id) {
      print("Invalid pizza number, please select 1 to 10")
      print(pizza)
      no <- readline("Please select pizza no (1 to 10) to order (or 'done' to finish): ")
    }
    
    no <- as.integer(no)
    quantity <- as.integer(readline(paste("Enter quanity for", pizza$item[pizza$id == no], ": ")))
    
    items <- c(items, pizza$item[pizza$id == no])
    quantities <- c(quantities, quantity)
  }
  pizza_order <- data.frame(
    item = items,
    quantity = quantities
  )
  

}

drink_order <- function() {
  items <- character()
  quantities <- integer()
  print("Do you like to order some drink? 📘")
  print("Here is the drink menu: ")
  print(drink)
  repeat {
    no <- readline("Please select drink no (11 to 14) to order (or 'done' to finish): ")
    
    if(tolower(no) == "done") {
      break
    }
    
    while (!no %in% drink$id) {
      print("Invalid drink number, please select 11 to 14")
      print(drink)
      no <- readline("Please select drink no (11 to 14) to order (or 'done' to finish): ")
    }
    
    no <- as.integer(no)
    quantity <- as.integer(readline(paste("Enter quanity for", drink[drink$id == no, "item"], ": ")))
    
    items <- c(items, drink[drink$id == no, "item"])
    quantities <- c(quantities, quantity)
  }
  drink_order <- data.frame(
    item = items,
    quantity = quantities
  )
  
  return(drink_order)

}


restaurant_order <- function() {
  print("Hello, welcome to our homemade pizza restaurant!")
  customer_name <- readline("What is your name?: ")
  customer_phone <- readline("What is your phone number?: ")
  print(paste("Welcome,", customer_name, "!", "How can I help you?"))
  pizza_order <- pizza_order()
  drink_order <- drink_order()
  total_order <- rbind(pizza_order, drink_order)
  order_time <- Sys.time()
  
  # fetch total cost
  total_order <- total_order %>%
    left_join(pizza_menu, by = c("item"= "item")) %>%
    mutate(total_price = quantity * price_thb)
  
  total_cost <- sum(total_order$total_price)
  
  print(paste0("Thank you 🍕,", customer_name," (", customer_phone, ")" ))
  print("Here is your order summary:")
  print(total_order[,-c(3)])
  print(paste("Total cost: ", total_cost, "THB"))
  
}


