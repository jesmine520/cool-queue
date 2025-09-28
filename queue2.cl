-- 栈节点类（用于实现队列的底层链表）
class StackNode inherits Object {
    data : Object;  -- 节点数据
    next : StackNode; -- 下一个节点指针

    -- 初始化节点：必须传入数据和下一个节点（避免void）
    init(i : Object, n : StackNode) : StackNode {
        {
            data <- i;   -- 数据非void
            next <- n;   -- 下一个节点非void（初始为void表示末尾）
            self;
        }
    };

    -- 获取数据（已初始化，不会返回void）
    getData() : Object { data };

    -- 获取下一个节点
    getNext() : StackNode { next };

    -- 设置下一个节点
    setNext(n : StackNode) : SELF_TYPE {
        {
            next <- n;
            self;
        }
    };
};

-- 队列类（用哨兵节点简化空队列处理）
class Queue inherits Object {
    front : StackNode; -- 哨兵节点（永远存在，代表队列头部）
    rear : StackNode;  -- 最后一个节点（队列尾部）

    -- 初始化队列：创建哨兵节点，front和rear都指向它
    initQueue() : SELF_TYPE {
        {
            let sentinel : StackNode <- (new StackNode).init(new Object, void);
            front <- sentinel;  -- 哨兵节点是队列的“虚拟头”
            rear <- sentinel;   -- 初始时队列为空，rear等于front
            self;
        }
    };

    -- 判断队列是否为空：哨兵节点等于rear时，队列为空
    isEmpty() : Bool {
        front == rear;  -- 关键修正！之前的isEmpty逻辑错误
    };

    -- 入队操作：在rear后面添加新节点
    enqueue(data : Object) : SELF_TYPE {
        {
            let newNode : StackNode <- (new StackNode).init(data, void); -- 新节点初始化
            rear.setNext(newNode);  -- 把新节点接到队尾
            rear <- newNode;        -- 更新rear为新节点
            self;
        }
    };

    -- 出队操作：移除哨兵节点的下一个节点（真正的队首元素）
    dequeue() : Object {
        if isEmpty() then {
            new Object;  -- 队列空，返回默认对象（Cool无异常）
        } else {
            let firstNode : StackNode <- front.getNext(); -- 真正的队首节点
            let data : Object <- firstNode.getData();     -- 取出数据
            front.setNext(firstNode.getNext());           -- 更新哨兵的next
            -- 如果出队后队列空了，重置rear为哨兵
            if isEmpty() then {
                rear <- front;
            }
            data;  -- 返回出队元素
        }
    };

    -- 获取队首元素（不移除）
    frontData() : Object {
        if isEmpty() then {
            new Object;
        } else {
            front.getNext().getData();  -- 哨兵的下一个节点是队首
        }
    };

    -- 打印队列元素（返回Object以满足类型要求）
    print() : Object {
        if isEmpty() then {
            (new IO).out_string("Queue is empty!
");
        } else {
            let current : StackNode <- front.getNext();  -- 从真正的队首开始遍历
            while not (isvoid current) loop {
                -- 直接匹配数据类型（current.getData()非void）
                case current.getData() of
                    s : String => (new IO).out_string(s);
                    i : Int => (new IO).out_int(i);
                    o : Object => (new IO).out_string(o.type_name());
                esac;
                (new IO).out_string(" ");  -- 元素间加空格
                current <- current.getNext();  -- 移动到下一个节点
            } pool;
            (new IO).out_string("
");  -- 换行使输出更清晰
        }
        self;  -- 返回self满足Object类型
    };

    -- 获取队列长度
    size() : Int {
        if isEmpty() then {
            0;
        } else {
            let count : Int <- 0;
            let current : StackNode <- front.getNext();
            while not (isvoid current) loop {
                count <- count + 1;
                current <- current.getNext();
            } pool;
            count;
        }
    };
};

-- 主类（测试队列）
class Main inherits IO {
    main() : Object {
        let q : Queue <- (new Queue).initQueue() in {
            -- 测试空队列
            q.print();  -- 输出：Queue is empty!

            -- 测试入队
            q.enqueue("First");
            q.enqueue(2);
            q.enqueue("Third");
            q.print();  -- 输出：First 2 Third 

            -- 测试查看队首
            out_string("
=== Testing Front Data ===
");
            if q.isEmpty() then {
                out_string("Queue is empty, no front data
");
            } else {
                out_string("Front: ");
                -- 匹配队首数据类型（确保输出正确）
                case q.frontData() of
                    s : String => out_string(s);
                    i : Int => out_int(i);
                    o : Object => out_string(o.type_name());
                esac;
                out_string("
");
            } fi;

            -- 测试出队
            out_string("
Dequeued: ");
            case q.dequeue() of
                s : String => out_string(s);
                i : Int => out_int(i);
                o : Object => out_string(o.type_name());
            esac;
            out_string("
");
            q.print();  -- 输出：2 Third 

            -- 再次出队
            out_string("
Dequeued: ");
            case q.dequeue() of
                s : String => out_string(s);
                i : Int => out_int(i);
                o : Object => out_string(o.type_name());
            esac;
            out_string("
");
            q.print();  -- 输出：Third 

            -- 出队至空
            out_string("
Dequeued: ");
            case q.dequeue() of
                s : String => out_string(s);
                i : Int => out_int(i);
                o : Object => out_string(o.type_name());
            esac;
            out_string("
");
            q.print();  -- 输出：Queue is empty!
        }
    };
};
