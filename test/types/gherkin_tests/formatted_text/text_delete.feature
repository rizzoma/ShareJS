Feature: Transformations of text delete operation
	Text delete operations should be transformed properly
	Scenario: td vs td, different places
		Given server with [{"t": "First", "params": {}}]
		And client1
		And client2
		When client1 submits [{"p": 0, "td": "F", "params": {}}]
		And client2 submits [{"p": 4, "td": "t", "params": {}}]
		And server receives operation 1 from client1
		Then server should send [{"p": 0, "td": "F", "params": {}}] to client2
		When server receives operation 1 from client2
		Then server should send [{"p": 3, "td": "t", "params": {}}] to client1
		And everyone should have [{"t": "irs", "params": {}}]
