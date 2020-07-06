/*
Copyright 2019 The Vitess Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package servenv

import (
	"io"
	"net/http"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"vitess.io/vitess/go/vt/servenv/testutils"
)

func TestLivenessHandler(t *testing.T) {
	server := testutils.HTTPTestServer()
	defer server.Close()
	resp, err := http.Get(server.URL + "/debug/liveness")
	if err != nil {
		t.Fatalf("http.Get: %v", err)
	}
	defer resp.Body.Close()

	// Make sure we can read the body, even though it's empty.
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		t.Fatalf("io.ReadAll: %v", err)
	}
	t.Logf("body: %q", body)
}

func TestLivenessHandlerDepool(t *testing.T) {
	assert := assert.New(t)
	server := testutils.HTTPTestServer()
	defer server.Close()

	resp, err := http.Get(server.URL + "/debug/liveness")
	if err != nil {
		t.Fatalf("http.Get: %v", err)
	}

	assert.Equal(
		http.StatusOK,
		resp.StatusCode,
		"should return 200 response code when depool file is not present",
	)

	// requires
	// ```
	// sudo mkdir -p /etc/etsy
	// sudo chmod 777 /etc/etsy
	// ```
	var path = "/etc/etsy/depool"
	_, err = os.Create(path)
	if err != nil {
		t.Error(err)
	}
	defer os.Remove(path)

	resp, err = http.Get(server.URL + "/debug/liveness")
	if err != nil {
		t.Fatalf("http.Get: %v", err)
	}
	assert.Equal(
		http.StatusServiceUnavailable,
		resp.StatusCode,
		"should return 503 response code when depool file is present",
	)
}
