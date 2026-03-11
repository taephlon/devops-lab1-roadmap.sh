# devops-lab1-roadmap.sh
A Bash script that to show CPU performance, Memory performance and Disk usages into logs, and kindly, this is my resume after researching for the formula for this project.

## The Resume.
First, its the requirements:

 **Requirements:**

You are required to write a script server-stats.sh that can analyse basic server performance stats. You should be able to run the script on any Linux server and it should give you the following stats:
```
1. Total CPU usage
2. Total memory usage (Free vs Used including percentage)
3. Total disk usage (Free vs Used including percentage)
4. Top 5 processes by CPU usage
5. Top 5 processes by memory usage
```

and then how do i make it?, and how is it works?, lets find out!.

**First, you should familiar with these commands:**
```
top -bn1
awk
ps -eo
--sort=-%cpu
```

### **Why** ``` top -bn1 ```**?**

This is a command that purposed to Grabs a single "snapshot" of the CPU without entering the interactive UI.

**Explanation of ```top -bn1```**

```top``` is a feature alike Windows task manager or MacOS activity monitor, simply it used for monitoring apps, system memory usage, and much more!.
also ```top``` has the feature alike Windows task manager, but with different touch and limited feature, its also has alot of options ot use, one of them is ```-bn1```, its a combination option between ```-b``` and ```-n```

```-b``` or the **Batch Mode** is used for *non-interactive* batch mode, simply the differences between using ```-b``` or not, is the way of the ```top``` command interact.

### **Why** ``` awk ```**?**

While a command like ```grep``` is great for finding a whole line that contains a specific word, ```awk``` is designed to reach inside that line, grab a specific "column" (or field), and do something with it—like math, reformatting, or filtering.

#### 1. It Sees in "Columns"
By default, awk treats every line of text as a table. It automatically splits the line wherever it sees a space.

If you have a line: User: admin ID: 501

awk sees $1 as User:, $2 as admin, $3 as ID:, and $4 as 501.

In this script, we use this to ignore the "fluff" words (like "MiB" or "Used") and grab just the raw numbers we need for our calculations.

#### 2. It's a Miniature Calculator
Unlike most basic text tools, awk has a built-in math engine. This is why we use it for your memory percentage:
```
awk '{print $3*100/$2}
```
It takes the value in column 3, multiplies it by 100, and divides it by column 2—all in one breath. Doing this in standard Bash would require much more complex code.

if u ran the `free -m` command, you'll see like this
```
total        used        free      shared  buff/cache   available
Mem:            7951        1234        4567         100        2150        6320
```
without the `awk`, you'll have to read that table manually
but with the `awk 'NR==2{print $3}'`, you telling the `awk` like *"Go to the 2nd row (NR==2) and just give me the 3rd number."* and the result will be `1234`.

### **Why** `ps -eo`**?**

The `ps` command stands for Process Status. By default, if you just type `ps`, it only shows you the programs running in your current terminal window (usually just `bash` and `ps` itself).

Since your script needs to see everything happening on the entire server, we use `-eo` to "unlock" the full view and customize exactly what columns we see.

1. The `-e` (Every)
Standard ps is shy; it only shows your own tasks.

The `-e` flag tells the system: "Show me every single process running on this machine, including those owned by other users and the system (root) itself."

2. The `-o` (User-Defined Format)
This is the most powerful part of the command. The -o stands for Output format.

Instead of letting `ps` decide what information to show you (which usually includes a lot of junk you don't need), `-o` lets you "hand-pick" your columns.

in the script, i use `ps -eo pid,ppid,cmd,%cpu`, why?

This tells the server: "I want a list of every process, but I only want to see these four specific columns:"

`pid`: The Process ID (The unique ID).

`ppid`: The Parent Process ID (The ID of the program that started this one).

`cmd`: The Name of the command/program.

`%cpu`: The percentage of CPU it’s currently using.

Why not just use `top`?
While top is great for a live dashboard, ps is much better for sorting and filtering inside a script.

By using ps `-eo ... --sort=-%cpu`, we can instantly force the list to put the "heaviest" programs at the very top.

`top` can be jumpy and harder to "grab" a clean list from compared to the surgical precision of ps `-eo`.

### **Why** `--sort=-%cpu`**?**

The `--sort` flag is how you tell the ps command to stop listing processes randomly and start organizing them by a specific metric, the something cool will happen with the symbols:

1. The Variable (`%cpu`)
This tells ps which "column" to use as the ruler for the ranking. Since we want to find the programs hogging the most power, we point it at the CPU percentage.

2. The Minus Sign (`-`)
This is the most important part of that string.

Without the minus (`%cpu`): The list sorts in ascending order (smallest to largest). You would see all the "0.0%" idle processes first, and the heavy hitters would be buried at the very bottom of the list.

With the minus (`-%cpu`): The list sorts in descending order (largest to smallest). This puts the "100.0%" or highest-usage processes at the very top of your screen where you can see them immediately.

How is it works?

In the script, we combined it like this:
`ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6`

`ps -eo ...`: Gets the list of all processes.

`--sort=-%cpu`: Puts the biggest CPU users at the top.

`| head -n 6`: Since the first line is just the "Header" (PID, CMD, etc.), we ask for the first 6 lines to get the header plus the Top 5 offenders.

a tip for **Memory Sorting**, If you wanted to find out what is eating your RAM instead of your CPU, you would simply change it to: `--sort=-%mem`.

## How to Use this Script?

To get this running on your server, follow these three quick steps:

1. Create the file:
```
nano server-stats.sh (then paste the code above).
```

2. Make it executable:
```
chmod +x server-stats.sh
```

3. Run it:
```
./server-stats.sh
```
<br/>

This project is part of [roadmap.sh](https://roadmap.sh/projects/server-stats) DevOps projects.
