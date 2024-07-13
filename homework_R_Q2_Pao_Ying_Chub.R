## 2. pao ying chub
hands <- c("hammer", "scissors", "paper")

get_choice <- function() {
  choice <- readline("Please choose 'hammer', 'scissors', or 'paper': ")
  
  while (!choice %in% hands) {
    print("Invalid action. Please choose 'hammer', 'scissors', or 'paper' ")
    choice <- readline("Enter your choice again 😊: ")
  }
  
  return(choice)
}


result <- function(player1, player2) {
  if(player1 == "paper" & player2 == "hammer" ||
     player1 == "scissors" & player2 == "paper" ||
     player1 == "hammer" & player2 == "scissors") {
    return(list(message = "You Win! 😊", user_win = TRUE, robot_win = FALSE))
  } else if (player2 == "paper" & player1 == "hammer" ||
             player2 == "scissors" & player1 == "paper" ||
             player2 == "hammer" & player1 == "scissors") {
    return(list(message = "You Lose 😭", user_win = FALSE, robot_win = TRUE))
  }
  else {
    return(list(message = "It's a tie", user_win = FALSE, robot_win = FALSE))
  }
  
}


play_game <- function() {
  games <- 0
  my_score <- 0
  robot_score <- 0
  game_list <- list()
  while (games < 10) {
    cat("Round ", games + 1)
    ## pao ying chub
    choice <- get_choice()
    robot_choice <- sample(hands, 1)
    
    winner <- result(choice, robot_choice)
    cat("Your choice:", choice, "\n")
    cat("Robot choice:", robot_choice, "\n")
    # update scores based on result
    print(winner$message)
    
    if (winner$user_win) {
      my_score <- my_score + 1
    } else if (winner$robot_win) {
      robot_score <- robot_score + 1
    }
    
    game_list <- c(game_list, winner)
    cat("Current Score (user vs robot) is ", my_score, ":", robot_score, "\n")
    games <- games + 1
  }
  
  
  cat("\n", "The result: ")
  cat("Your score vs Robot score is ", my_score, ":", robot_score, "\n")
  if (my_score > robot_score) {
    print("Congratulation!!! You win over robot")
  } else if (my_score < robot_score) {
    print("Sorry! You Lose.")
  } else {
    print("It's a tie")
  }
}

play_game()
