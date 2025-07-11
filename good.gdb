set print pretty on
set pagination off

define bre
    break thread_sleep
    break thread_awake
end

define connect
    target remote localhost:1234
end

# 현재 running_thread 정보 출력
define running
    p *(struct thread *) ((int)$esp & ~0xfff)
end

# ready_list 내부 thread 모든 정보 출력
define ready
    set $re = ready_list.head.next
    while($re != &ready_list.tail)
        set $rt = (struct thread *)((char *) $re - 48)
        p $re
        p $rt
        p *$rt
        set $re = $re->next
    end
end

# simple_ready라는 의미 / ready_list안에 어떤 thread가 있는지만 check
define sready
    set $e = ready_list.head.next
    while ($e != &ready_list.tail)
        set $t = (struct thread *)((char *)$e - 48)
        printf "%-5d %-16s %-8d\n", $t->tid, $t->name, $t->status
        set $e = $e->next
    end
end

define blocked
    set $be = blocked_list.head.next
    while($be != &blocked_list.tail)
        set $bt = (struct thread *)((char *) $be - 48)
        p $be
        p $bt
        p *$bt
        set $be = $be->next
    end
end

define sblocked
    set $e = blocked_list.head.next
    while ($e != &blocked_list.tail)
        set $t = (struct thread *)((char *)$e - 48)
        printf "%-5d %-16s %-8d %-5d\n", $t->tid, $t->name, $t->status, $t->tick_to_awake
        set $e = $e->next
    end
end

define all
    set $ae = all_list.head.next
    while($ae != &all_list.tail)
        set $at = (struct thread *)((char *) $ae - 32)
        p $ae
        p $at
        p *$at
        set $ae = $ae->next
    end
end

define sall
    set $e = all_list.head.next
    while ($e != &all_list.tail)
        set $t = (struct thread *)((char *)$e - 32)
        printf "%-5d %-16s", $t->tid, $t->name
        
        if $t->status == THREAD_RUNNING
            printf " running\n"
        else
            if $t->status == THREAD_READY
                printf " ready\n"
            else
                if $t->status == THREAD_BLOCKED
                    printf " blocked\n"
                else
                    printf " unknown(%d)\n", $t->status
                end
            end
        end

        set $e = $e->next
    end
end

define size
    printf "all_list_size: %d\n", list_size(&all_list)
    printf "blocked_list_size: %d\n", list_size(&blocked_list)
    printf "ready_list_size: %d\n", list_size(&ready_list)
end



define sizeof
    printf "%-15s : %d\n", "tid",             sizeof(((struct thread*)0)->tid)
    printf "%-15s : %d\n", "status",          sizeof(((struct thread*)0)->status)
    printf "%-15s : %d\n", "name[16]",        sizeof(((struct thread*)0)->name)
    printf "%-15s : %d\n", "stack",           sizeof(((struct thread*)0)->stack)
    printf "%-15s : %d\n", "priority",        sizeof(((struct thread*)0)->priority)
    printf "%-15s : %d\n", "allelem",         sizeof(((struct thread*)0)->allelem)
    printf "%-15s : %d\n", "tick_to_awake",   sizeof(((struct thread*)0)->tick_to_awake)
    printf "%-15s : %d\n", "elem",            sizeof(((struct thread*)0)->elem)
    printf "%-15s : %d\n", "magic",           sizeof(((struct thread*)0)->magic)
end
    
