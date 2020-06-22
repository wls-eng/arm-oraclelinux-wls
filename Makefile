all:
	cp subtemplate-src/aadNestedTemplate.md admin
	cp subtemplate-src/aadNestedTemplate.md cluster
	cp subtemplate-src/aadNestedTemplate.md dynamic-cluster
	cp subtemplate-src/dbTemplate.md admin
	cp subtemplate-src/dbTemplate.md cluster
	cp subtemplate-src/dbTemplate.md dynamic-cluster
	cp subtemplate-src/appGatewayNestedTemplate.md cluster

