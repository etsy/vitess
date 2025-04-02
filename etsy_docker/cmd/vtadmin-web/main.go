// package main

// import (
// 	"fmt"
// 	"log"
// 	"net/http"
// )

// func main() {

// 	// fs := http.FileServer(http.Dir("/vitess/web/vtadmin/build/"))
// 	// http.Handle("/", fs)
// 	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
// 		http.ServeFile(w, r, "/vitess/web/vtadmin/build/index.html")
// 	})

// 	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
// 		fmt.Fprintf(w, "ok")
// 	})

// 	log.Print("Listening on :14201...")
// 	err := http.ListenAndServe(":14201", nil)
// 	if err != nil {
// 		log.Fatal(err)
// 	}
// }

package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"path/filepath"
)

func main() {
	const staticPath = "/opt/vitess/vtadmin-web"
	const indexPath = "index.html"

	fileServer := http.FileServer(http.Dir(staticPath))

	log.Print("Listening on :14201...")
	http.ListenAndServe(":14201", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		path, err := filepath.Abs(r.URL.Path)
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}
		if path == "/health" {
			fmt.Fprintf(w, "ok")
			return
		}

		path = filepath.Join(staticPath, r.URL.Path)

		_, err = os.Stat(path)
		if os.IsNotExist(err) {
			// file does not exist, serve index.html
			http.ServeFile(w, r, filepath.Join(staticPath, indexPath))
			return
		} else if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		fileServer.ServeHTTP(w, r)

	}))
}
