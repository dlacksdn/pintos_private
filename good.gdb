target remote localhost:1234
set print pretty on
set pagination off

break thread_sleep
break thread_awake

define running
    p *(struct thread *) ((int)$esp & ~0xfff)
end

define ready
    set $address = &ready_list
    set $re = ((struct list *) $address) -> head.next
    set $rt = (struct thread *)((char *) $re - 48)
    p $re
    p $rt
    p *$rt
end

define readyn
    set $re = $re -> next
    set $rt = (struct thread *)((char *) $re - 48)
    p $re
    p $rt
    p *$rt
end

define blocked
    set $address = &blocked_list
    set $be = ((struct list *) $address) -> head.next
    set $bt = (struct thread *)((char *) $be - 48)
    p $be
    p $bt
    p *$bt
end

define blockedn
    set $be = $be -> next
    set $bt = (struct thread *)((char *) $be - 48)
    p $be
    p $bt
    p *$bt
end

define all
    set $address = &all_list
    set $ae = ((struct list *) $address) -> head.next
    set $at = (struct thread *)((char *) $ae - 32)
    p $ae
    p $at
    p *$at
end

define alln
    set $ae = $ae -> next
    set $at = (struct thread *)((char *) $ae - 32)
    p $ae
    p $at
    p *$at
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
    
