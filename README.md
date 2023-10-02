This is a demo for PennOS project. For confidential issue, we only provide the executables. Please get in contact if you need to see source code for interview purpose!

## Team Member: 

* Zhijun Zhuang
* Keyan Zhai
* Bowen Jiang
* Wendi Zhang

## Extra credit answers

Memory-leak free

## Compilation Instructions

run make under the repository root directory. Two executables (pennos, pennfat) will be generated under /bin.

## Overview of work accomplished
Our team has successfully accomplished all of the requirements for the implementation of PennOS, our own UNIX-like operating system. The system is similar to standard UNIX with a priority scheduler, and it is implemented using the ucontext library to split resources across multiple instance like a multi-process system. We have also implemented a FAT file system, PennFAT, for our operating system to mount, and a simple shell for user interaction with our PennFAT and PennOS. Our implementation utilizes the SIGALRM-based scheduler for context switching. The PennFAT file system allows for the creation, modification, and removal of files under the top-level directory, while allowing interactions with our PennOS through a list of system calls. We have also provided job control, stdin/stdout redirection, and a functional set of built-in commands for testing and exploring the operating system within the shell. Additionally, our team has accomplished the extra credit of ensuring no memory leaks or valgrind errors. Zhijun Zhuang and Keyan Zhai worked on the kernal while Bowen Jiang and Wendi Zhang worked on the file system.

## Description of code and code layout

#### **Kernel**

- `scheduler.c` and `scheduler.h`: 

These files implement a basic priority scheduler. The scheduler keeps track of all the pcbs for processes in ready queue(with three different priorities), stopped queue, blocked queue and zombie queue. Users can use system calls to change the state of a process, and at every scheduler tick triggered by SIGALAM, the scheduler will poll all the processes, update the queues they belong to and choose the next process to run.

- `pcb.c` and `pcb.h`: 

These files define the initialization and manipulations of Process Control Block (PCB) data structure, which stores information about a running process, including its state, priority, children and parent process, etc. It also contains the macros of process states.

- `kernel.c` and `kernel.h`:

These files contain the global variables and kernel-level functions(with prefix k_) used by the pennos.

We define two global pointers for the scheduler:`global_scheduler_ptr`, which points to the scheduler used by other modules in the operating system. `active_pcb_ptr`, which is global pointer to the currently active process.

- `logger.c` and `logger.h`:

These files contain the logger functions to log for the scheduler and kernel level functionality. 


- `ufuncs.c` and `ufuncs.h`: 

These files contain the user level functions such as `u_zombify`, `u_orphanify` `u_cat`, etc. The user level functions can be called directly by the user from a shell, but they can not call kernel level functions or modify the kernel side data structures(pcb, scheduler) directly. Instead, they can use system calls (defined in uprocess.h, with prefix p_) to do that.

- `uprocess.c` and `uprocess.h`:   

These files contain the system calls.

- `shell.c` and `shell.h`: 

These files implement the user shell, which allows users to interact with the operating system through a command-line interface.

- `usignal.c` and `usignal.h`

These files contain signal definitions and macros to check child status.

#### **PennFAT**

- `global.c` and `global.h`

These files contain global variables about the file system metadata that other files of PennFAT need to know.

- `interface.c` and `interface.h`

These files specifiy all the user commands that either a standalone PennFAT or a PennOS can accept from the shell, including `mkfs`, `mount` and `umount` who create, mount, and unmount a file system, `touch`, `mv`, `cat`, `cp`, `ls`, and `chmod` who manipulate files in the PennFAT file system or file R/W interactions between PennFAT and the host OS.

- `pennfat.c` and `pennfat.h`

These files specifiy a standalone PennFAT shell that calls functions in `interface.h` and `interface.h` to process user commands in a while loop.

- `pennfat_utils.c` and `pennfat_utils.h`

These files contains some helper functions that functions in `interface.h` need.

- `syscall.c` and `syscall.h`

These files contains the system call functions that `interface.c` or the PennOS will call to interact with files in the PennFAT file system at the kernel level, such as `f_open`, `f_close`, `f_read`, `f_write`, `f_close`, `f_lseek`, `f_unlink`, and `f_ls`. These system calls will manipulate file descriptor tables and call functions in `syscall_utils.c` and `syscall_utils.h`.

- `syscall_utils.c` and `syscall_utils.h`

System calls in `syscall.c` and `syscall.h` call helper functions in these files to implement the actual interactions with the PennFAT. For example, syscall `f_read` will call `read_from_pennfat` to read data from PennFAT, `f_write` will call `write_to_pennfat` to write data to PennFAT, and `f_seek` with the `F_SEEK_END` mode will call `get_end_file_idx` to reposit the file pointer to the end of the current file. 