INNOVAD=innovad
INNOVAGUI=innova-qt
INNOVACLI=innova-cli
B1_FLAGS=
B2_FLAGS=
B1=-datadir=1 $(B1_FLAGS)
B2=-datadir=2 $(B2_FLAGS)
BLOCKS=1
ADDRESS=
AMOUNT=
ACCOUNT=

start:
	$(INNOVAD) $(B1) -daemon
	$(INNOVAD) $(B2) -daemon

start-gui:
	$(INNOVAGUI) $(B1) &
	$(INNOVAGUI) $(B2) &

generate:
	$(INNOVACLI) $(B1) -generate $(BLOCKS)

getinfo:
	$(INNOVACLI) $(B1) -getinfo
	$(INNOVACLI) $(B2) -getinfo

sendfrom1:
	$(INNOVACLI) $(B1) sendtoaddress $(ADDRESS) $(AMOUNT)

sendfrom2:
	$(INNOVACLI) $(B2) sendtoaddress $(ADDRESS) $(AMOUNT)

address1:
	$(INNOVACLI) $(B1) getnewaddress $(ACCOUNT)

address2:
	$(INNOVACLI) $(B2) getnewaddress $(ACCOUNT)

stop:
	$(INNOVACLI) $(B1) stop
	$(INNOVACLI) $(B2) stop

clean:
	find 1/regtest/* -not -name 'server.*' -delete
	find 2/regtest/* -not -name 'server.*' -delete

docker-build:
	docker build --tag innova-testnet-box .

docker-run:
	docker run -ti innova-testnet-box
