from kafka import KafkaConsumer

def get_data():
    bootstrap_servers = ['localhost:9092'] #Define the server and the port
    topicName = "" #Define topic name depending of the producer
    consumer = KafkaConsumer (topicName, group_id ='group1',bootstrap_servers =
                            bootstrap_servers)
    for msg in consumer:
        print("Topic Name=%s,Message=%s"%(msg.topic,msg.value))
        yield msg

def send_data():
    pass
