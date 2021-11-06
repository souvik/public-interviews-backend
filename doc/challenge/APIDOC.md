# Mamo Pay - Backend Solution
## Prerequisite
#### Build the application using docker
```bash
$ cp docker-compose.example.yaml docker-compose.yaml
$ docker compose build
$ docker compose up
```
#### To run all test cases
```bash
$ docker compose exec app bin/rspec
```
## API: Send money
#### HTTP Method: POST, URI: /accounts/send_money

You can pass email or phone number to represent credit and debit accounts. Example below:

1. Passing account's email-id 
```bash
$ curl --request POST --header "Content-Type: application/json" \
          http://localhost:3010/accounts/send_money \
          --data '{"account": {"creditor": {"email": "jennifer.tanner@mailinator.com"}, "debitor": {"email": "melissa.kirk@mailinator.com"}, "amount": 10.09}}'
```
2. Passing account's phone number
```bash
$ curl --request POST --header "Content-Type: application/json" \
          http://localhost:3010/accounts/send_money \
          --data '{"account": {"creditor": {"phone": "3120986735"}, "debitor": {"phone": "5168683427"}, "amount": 10.09}}'
```

## API: Receive money
#### HTTP Method: POST, URI: /accounts/receive_money

You can pass email or phone number to represent credit and debit accounts. Example below:

1. Passing account's email-id 
```bash
$ curl --request POST --header "Content-Type: application/json" \
          http://localhost:3010/accounts/receive_money \
          --data '{"account": {"creditor": {"email": "jennifer.tanner@mailinator.com"}, "debitor": {"email": "melissa.kirk@mailinator.com"}, "amount": 10.09}}'
```
2. Passing account's phone number
```bash
$ curl --request POST --header "Content-Type: application/json" \
          http://localhost:3010/accounts/receive_money \
          --data '{"account": {"creditor": {"phone": "3120986735"}, "debitor": {"phone": "5168683427"}, "amount": 10.09}}'
```

## API: Transaction history
#### HTTP Method: GET, URI: /accounts/:account_id/transactions

To get a transaction history of an account you need the "id" value of the account. Example below:
```bash
$ curl --request GET --header "Content-Type: application/json" \
          http://localhost:3010/accounts/1/transactions
```
