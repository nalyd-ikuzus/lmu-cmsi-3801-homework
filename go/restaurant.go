package main

import (
	"log"
	"math/rand"
	"time"
	"sync"
	"sync/atomic"
)

// A little utility that simulates performing a task for a random duration.
// For example, calling do(10, "Remy", "is cooking") will compute a random
// number of milliseconds between 5000 and 10000, log "Remy is cooking",
// and sleep the current goroutine for that much time.
func do(seconds int, action ...any) {
    log.Println(action...)
    randomMillis := 500 * seconds + rand.Intn(500 * seconds)
    time.Sleep(time.Duration(randomMillis) * time.Millisecond)
}

//Order struct holds the customer, unique id, cook, and the reply channel so that the customer can get the food
type Order struct {
	customer string
	id uint64
	preparedBy string
	reply chan *Order

}

//Also need a mechanism to gen the next order id - similar to java, you need atomics
var nextId atomic.Uint64
func GenerateNextID() uint64 {
	return nextId.Add(1)
}

//Waiter channel to take orders from the customers to the chefs - Can only hold 3 orders at once
var Waiter = make(chan *Order, 3)

//Customer function: keeps trying to order food.  If order is taken eats food and moves onto next order until 5 meals have been eaten
func Customer(name string, wg *sync.WaitGroup){
	//Ensure we decrement the WaitGroup when the Customer is done
	defer wg.Done()
	//Customer eats 5 meals and then goes home
	for mealsEaten := 0; mealsEaten < 5; {
		//Place an Order
		myOrder := Order{name: name, id: GenerateNextID(), preparedBy: "", reply: make(chan *Order)}
		log.Println(name, "placing order", myOrder.id)
		select { //Start timeout
		case Waiter <- &myOrder:
			//Waiter took order case: wait for reply and then eat
			orderReply := <-myOrder.reply
			do(2, "EAT", name, "eating cooked order", orderReply.id, "prepared by", orderReply.preparedBy)
			mealsEaten++
		case <-time.After(7 * time.Second):
			//Timeout case
			do(5, name, "waited too long, abandoning order", myOrder.id)
		}
	}
	//Customer is finished
	log.Println(name, "going home")
}

//Cook daemon: Keeps taking orders from the waiter and cooking them before returning them to the customer
func Cook(name string){
	//log that the cook is starting
	log.Println(name, "starting work")
	for { //Loop forever
		//Wait for order from waiter
		var order = <- Waiter
		//Cook it
		do(10, name, "is cooking order", order.id, "for", order.customer)
		//Put the name of the cook in the order
		order.preparedBy = name
		//Return the order
		order.reply <- order:
	}
}

func main() {
	customers := [10]string{
		"Ani", "Bai", "Cat", "Dao", "Eve", "Fay", "Gus", "Hua", "Iza", "Jai",
	}
	log.Println("Welcome to the Restaurant")
	var wg sync.WaitGroup
	//In a loop start each customer as a goroutine
	for _, customer := range customers {
		wg.Add(1)
		go Customer(customer, &wg)
	}

	//Start 3 cooks: Remy, Linguini, and Colette
	go Cook("Remy")
	go Cook("Linguini")
	go Cook("Colette")

	//Wait for all customers to finish before closing the restaurant
	wg.Wait()
	log.Println("Restaurant closing")
}