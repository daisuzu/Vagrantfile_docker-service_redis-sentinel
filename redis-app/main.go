package main

import (
	"flag"
	"fmt"
	"net/http"
	"strings"

	"gopkg.in/redis.v4"
)

var addrFlag string

func main() {
	flag.StringVar(&addrFlag, "addr", "localhost:26379", "")
	flag.Parse()

	cli := redis.NewFailoverClient(&redis.FailoverOptions{
		MasterName:    "mymaster",
		SentinelAddrs: strings.Split(addrFlag, ","),
	})

	http.HandleFunc("/clients", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, cli.ClientList().String())
	})

	http.ListenAndServe(":8080", nil)
}
