class StackNode inherits Object{
	data : Object;
	next : StackNode;

--初始化
	init( i : Object, n : StackNode) : StackNode {
		{
			data <- i;
			next <- n;
			self;
		}	
	};
	
--返回节点数据
	getData() : Object {
		data
	};
	
--返回下一个节点
	getNext() : StackNode{
		next
	};

--设置下一个节点
	setNext(n : StackNode) : SELF_TYPE{
		{
			next <- n;
			self;
		}
	};
};

--队列
class Queue inherits Object{

	--队列首个元素
	front : StackNode;
	
	--队列末尾元素
	rear : StackNode;

	--初始化队列操作
	initQueue() : SELF_TYPE{
		{
			let v1 : StackNode in front <- v1;
			let v2 : StackNode in rear <- v2;
			self;
		}
	};

	--判断队列是否为空
	isEmpty() : Bool{
		isvoid front
	};

	--enqueue(data) 入队操作
	enqueue(data : Object) : SELF_TYPE{
		{
			let v : StackNode in
			let newNode : StackNode <- (new StackNode).init(data, v) in {
				if isEmpty() then{
					front <- newNode;
					rear <- newNode;
				}
				else{
					rear.setNext(newNode);
					rear <- newNode;
				} fi;
			};
			self;
		}
	};

	--dequeue() 出队操作
	dequeue() : Object {
		if  isEmpty() then{
			new Object;
		}
		else {
			let d : Object <- front.getData() in{
				front <- front.getNext();
				if isEmpty() then{
					let v : StackNode in rear <- v;
				}else{
					new Object;
				}fi;
				d;
			};	
		}fi
	};
			
	--frontData() 返回队首元素，但不移除
	frontData() : Object{
		if isEmpty() then{
			new Object;
		}
		else {
			front.getData();
		}fi
	};

	--print() 打印队列内所有元素
	print() : Object{
		if isEmpty() then{
			(new IO).out_string("Queue is empty!\n");
		}
		else{
			let temporalPoint : StackNode <- front in
			while not isvoid temporalPoint loop{
				case temporalPoint.getData() of		--处理不同元素的data
					s : String => (new IO).out_string(s);
					i : Int => (new IO).out_int(i);
					o : Object => (new IO).out_string(o.type_name());
				esac;
				(new IO).out_string(" ");
				temporalPoint <- temporalPoint.getNext();
			}pool;
		}fi
	};

	--获取队列长度
	size() : Int {
		let count : Int <- 0, temporalPoint : StackNode<- front in{
		while not isvoid temporalPoint loop{
			count <- count + 1;
			temporalPoint <- temporalPoint.getNext();
		}pool;
		count;
		}	
	};
};

class Main inherits IO {
    main() : Object {
        let q : Queue <- (new Queue).initQueue() in {
            -- 测试空队列
            q.print();  -- 应输出 "Queue is empty!"
            
            -- 测试入队
            q.enqueue("First");
            q.enqueue(2);
            q.enqueue("Third");
            q.print();  -- 应输出 "First 2 Third"
            
            -- 测试查看队首
           out_string("\n=== Testing Front Data ===\n");
    	  if q.isEmpty() then {
        	out_string("Queue is empty, no front data\n");
    	  } else {
      		  out_string("Front: ");
      		  case q.frontData() of
        		  s : String => out_string(s);
         		  i : Int    => out_int(i);
       	 		 o : Object => out_string(o.type_name());
      		  esac;
        out_string("\n");
      } fi;
            
            -- 测试出队
            q.dequeue();
            q.print();  -- 应输出 "2 Third"
            
            -- 测试出队至空
            q.dequeue();
            q.dequeue();
            q.print();  -- 应输出 "Queue is empty!"
        }
    };
};
