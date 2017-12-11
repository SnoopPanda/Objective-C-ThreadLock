### 盘点iOS开发中的线程锁

> 线程锁使用场景：在多个线程下操作同一个数据，数据将变得不安全。比方说：在多个线程中删除一个数组的首个元素，你不知道在多线程操作过程中，该元素还存不存在，如果不存在程序就会崩溃。
加了线程锁以后，就能保证在A线程访问数据的时候，B线程就没有办法访问。只有在A线程执行完解锁操作以后，B线程才有资格去访问。也就是说该数据只允许被一个线程访问，这就是线程安全。

###### 针对这个问题，我们一起来盘点下iOS开发中的线程锁。
###### 一、 原子锁: atomic
`atomic`是`@property`创建属性默认的关键字，使用`atmoic`关键字会在属性的setter方法里面加上了，如下面代码。因为手机设备资源有限，为了提高效率在iOS开发中我们一般上使用`nonatomic`关键字。
		
      {lock}
      if (property != newValue) {
         [property release]; 
         property = [newValue retain]; 
      }    
      {unlock}
[Objective-C Property Attributes](https://academy.realm.io/posts/tmi-objective-c-property-attributes/)这篇文章中详细解释了`atomic`和`nonatomic`。划重点：**Atomic is really commonly confused with being thread-safe, and that is not correct. You need to guarantee your thread safety other ways.**就是说用了atomic关键字并不能保证数据是线程安全的，它只能保证你拿到的值是完好无损的。
	  
    - (void)multiOperation {
	    for (int i=0; i<10; i++) {
	        NSString *queue = [NSString stringWithFormat:@"queue-%d", i];
	        dispatch_queue_t q = dispatch_queue_create([queue UTF8String], NULL);
	        dispatch_async(q, ^{
	            self.string = queue;
	        });
	    }
	}
    调用多次的结果：
    string === queue-1 
	string === queue-5 
	string === queue-4 
	string === (null) 
	string === (null) 
	string === queue-0 
	string === queue-8 
	string === queue-6 
上面这个例子里面string属性是`nonatomic`修饰的，连续多次调用结果是随机的，中间也会出现`string === (null) `的情况。如果用`atomic`来修饰结果也是随机的但中间不会出现`string === (null) `，这也就解释了上面的结论：**atomic关键字并不能保证数据是线程安全的，它只能保证你拿到的值是完好无损的。**
为什么会出现`string === (null) `呢？回到setter代码块，如果不加原子锁该属性在多线程赋值的过程中碰巧两个线程接连执行了`release`操作，当该属性的retainCount=0的时候也就释放了，所以就出现了null值。
###### 二、NSLock & NSCondition & NSConditionLock & NSRecursiveLock
这四个是苹果封装好的线程锁对象，统一定义在`NSFoundation -> NSLock.h`文件里面，都遵守了`NSLocking`协议。
	
      @protocol NSLocking
	  - (void)lock; 
	  - (void)unlock;
	  @end
所以，基本使用也很类似：
1. 初始化一个锁对象 
  2. 执行上锁操作`[xxx lock] `
3. 执行解锁操作`[xxx unlock]`

不同的是使用场景：

**NSLock**：最简单的线程锁，没有复杂的需求使用它就好了。

**NSCondition & NSConditionLock**：条件锁，满足一定条件触发的线程锁。

**NSRecursiveLock**：递归锁，在递归调用使用线程锁很容易造成死锁，递归锁就是为了解决这些问题设计的。具体使用参照：[NSRecursiveLock递归锁的使用](http://www.cocoachina.com/ios/20150513/11808.html)
###### 三、synchronized关键字
为了避免多个线程同时执行同一段代码，Objective-C提供了`@synchronized()`。它可以对一段代码进行加锁，同一时间只允许一个线程执行该代码，其他试图执行该代码的线程都会被阻塞。和NSLock等线程锁对比，`@synchronized()`使用起来更加方便，可读性更高。
至于`@synchronized()`的底层实现，可以看这篇文章[关于 @synchronized，这儿比你想知道的还要多](http://yulingtianxia.com/blog/2015/11/01/More-than-you-want-to-know-about-synchronized/)。
###### 四、信号量  dispatch_semaphore_t
 信号量(dispatch_semaphore)： 信号量是一个整形值并且具有一个初始计数值，并且支持两个操作：信号通知和等待。当一个信号量被信号通知，其计数会被增加。当一个线程在一个信号量上等待时，线程会被阻塞（如果有必要的话），直至计数器大于零，然后线程会减少这个计数。
 
在GCD中有三个函数是semaphore的操作，分别是：
 dispatch_semaphore_create ：创建一个semaphore，需要传入一个long类型的数，作为信号总量。
 dispatch_semaphore_signal ：发送一个信号，让信号总量加1。
 dispatch_semaphore_wait ：发送一个等待信号，让信号总量减1
  
        dispatch_group_t group = dispatch_group_create();   
	    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);   
	    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);   
	    for (int i = 0; i < 100; i++)   
	    {   
	        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);   
	        dispatch_group_async(group, queue, ^{   
	            NSLog(@"%i",i);   
	            sleep(2);   
	            dispatch_semaphore_signal(semaphore);   
	        });   
	    }   
	    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);   
	    dispatch_release(group);   
	    dispatch_release(semaphore);
这段代码创建了一个初始值为10的信号量，每一次循环都会发送一个等待信号，并创建一个线程，该线程执行完以后发送一个信号。当创建了10个线程以后，for循环就会阻塞，等待有线程执行完以后才会继续执行。这就形成了对并发的控制，上面是创建了一个并发数为10的线程队列。如果要做一个并发数为1的线程锁，只需要创建一个初始值为1的信号量就可以了。

###### 五、补充 POSIX(pthread_mutex) & OSSpinLock

  POSIX(pthread_mutex)：[Linux 线程锁详解](http://blog.chinaunix.net/uid-26885237-id-3207962.html)
  
  OSSpinLock：[不再安全的 OSSpinLock](https://blog.ibireme.com/2016/01/16/spinlock_is_unsafe_in_ios/)
  
PS：POSIX(pthread_mutex)Linux底层的API，复杂的多线程处理建议使用，并且可以封装自己的多线程；OSSpinLock已经出现了BUG，导致并不能完全保证是线程安全的。
-----
DEMO：
[Objective-C-ThreadLock](https://github.com/SnoopPanda/Objective-C-ThreadLock)

参考文章：
[iOS多线程 -各种线程锁的简单介绍](http://www.jianshu.com/p/35dd92bcfe8c)
[深入理解 iOS 开发中的锁](https://bestswifter.com/ios-lock/)
