## import required library
from random import choice

## define function
def pao_ying_chub():
    print("Let's play Pao Ying Chub! 🙂")
    hands = ["hammer", "scissors", "paper"]
    end = False
    player_score = 0
    computer_score = 0

    while not(end):
        computer_choice = choice(hands)
        player_choice = input("Please choose your hand: [hammer, scissors, paper] or `n` to quit: ").lower()
        print(f"Computer choice: {computer_choice}")
        if player_choice == "n":
            end = True
        elif player_choice not in hands:
            print("Invalid choice! Please entry your choice again: [hammer, scissors, paper]")
        else:
                if player_choice == computer_choice:
                    print("It's a tie!")
                elif player_choice == "hammer" and computer_choice == "scissors":
                    print("You win!")
                    player_score += 1
                elif player_choice == "paper" and computer_choice == "hammer":
                    print("You win!")
                    player_score += 1
                elif player_choice == "scissors" and computer_choice == "paper":
                    print("You win!")
                    player_score += 1
                else:
                    print("You lose!")
                    computer_score += 1

    if player_score > computer_score:
        print("You win the game!")
    elif player_score < computer_score:
        print("You lose the game!")
    else:
        print("It's a tie!")

    print(f"Final score is: {player_score} - {computer_score}")

## play games
pao_ying_chub()
