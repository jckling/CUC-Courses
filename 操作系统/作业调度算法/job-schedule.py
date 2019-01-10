from datetime import datetime, timedelta

# 后备作业
class backup():
    def __init__(self, attr: list):
        num, name, submit, need = attr
        self.num, self.name, self.submit, self.need = int(num), name, datetime.strptime(submit, '%H:%M'), timedelta(minutes=int(need))

# 调度作业
class job():
    def __init__(self, j, start, finish, wait, schedule, weight_schedule):
        self.num, self.name, self.submit, self.need = j.num, j.name, j.submit.time(), j.need
        self.start, self.finish, self.wait, self.schedule, self.weight_schedule = start.time(), finish.time(), wait, schedule, weight_schedule

# 输出信息
# 编号、名称、提交时间、要求服务运行时间、开始时间、完成时间、等待时间、周转时间、加权周转时间
def output(job_lst: list):
    p = "{:<4} {:<4} {:<8} {:<8} {:<8} {:<8} {:<8} {:<8}  {:<8}"
    q = "{:<2} {:>6} {:>11} {:>11} {:>12} {:>11} {:>11} {:>11}  {:>10}"
    print(p.format("编号", "名称", "提交时间", "要求时间", "开始时间", "完成时间", "等待时间", "周转时间", "加权周转时间"))
    for j in job_lst:
        print(q.format(j.num, j.name, str(j.submit), str(j.need), str(j.start), str(j.finish), str(j.wait), str(j.schedule), str(j.weight_schedule)))
    avg, weighted_avg = average(job_lst)
    print("平均周转时间：", avg)
    print("平均带权周转时间(分)：", weighted_avg)

# 平均周转时间、平均带权周转时间
def average(job_lst: list):
    avg_schedule, avg_weight_schedule = timedelta(hours=0, minutes=0, seconds=0), 0
    for j in job_lst:
        avg_schedule = avg_schedule + j.schedule
        avg_weight_schedule = avg_weight_schedule + j.weight_schedule
    return avg_schedule/len(job_lst), avg_weight_schedule/len(job_lst)

# 调度作业，添加到调度队列
def add_output(output_lst: list, j: job, start: datetime):
    finish = start + j.need
    schedule = finish - j.submit
    weight_schedule = schedule / j.need
    wait = start - j.submit
    output_lst.append(job(j, start, finish, wait, schedule, weight_schedule))
    start = start + j.need
    return start, wait

# 调度
def Schedule(backup_lst: list):
    n = len(backup_lst)
    start = backup_lst[0].submit
    outputs = []
    first_job = backup_lst[0]
    start, wait = add_output(outputs, first_job, start)
    i = 1
    del_backup(backup_lst, first_job)
    while len(outputs) < n:
        if add_backup(backup_lst, start.time()):    # 调度时提交新作业
            n = n + 1
        # next_job = find_next(backup_lst)                      # 先来先服务(First Come First Serve, FCFS)
        # next_job = find_shortest(backup_lst, start)         # 短作业优先(Short Job First, SJF)
        next_job = find_highratio(backup_lst, start)        # 最高响应比优先(Highest Response Ratio Next, HRRN)
        start, wait = add_output(outputs, next_job, start)
        i = i + 1
    return outputs


def job_by_num(backup_lst:list, num: int):
    for backup in backup_lst:
        if backup.num == num:
            return backup

# 从后备队列中删除作业
def del_backup(backup_lst: list, del_backup: backup):
    backup_lst.remove(del_backup)

# FCFS
def find_next(backup_lst: list):
    job = backup_lst[0]
    del_backup(backup_lst, job)
    return job

# SJF
def find_shortest(backup_lst: list, now: datetime):
    temp_lst = []
    for backup in backup_lst:
        if backup.submit <= now:
            temp_lst.append(backup)
    if temp_lst:
        temp_lst.sort(key=lambda x: x.need, reverse=False) # 按要求服务时间排序
        job = job_by_num(backup_lst, temp_lst[0].num)
    else:
        job = backup_lst[0]    # 如果不符合条件返回顺序第一个
    del_backup(backup_lst, job)
    return job

# 响应比计算公式为：RP = (等待时间+要求服务时间)/要求服务时间
def ratio(back: backup, now: int):
    return (now-back.submit+back.need)/back.need

# HRRN
def find_highratio(backup_lst: list, now: datetime):
    temp_lst = []
    for backup in backup_lst:
        if backup.submit <= now:
            temp_lst.append(backup)
    if temp_lst:
        temp_lst.sort(key=lambda x: ratio(x, now), reverse=True) # 按响应比排序
        job = job_by_num(backup_lst, temp_lst[0].num)
    else:
        job = backup_lst[0]    # 如果不符合条件返回顺序第一个
    del_backup(backup_lst, job)
    return job

# 从文件中读取后备队列
def readfile(path):
    backup_lst = []
    with open(path, 'r+') as f:
        lines = f.readlines()
        for line in lines:
            backup_lst.append(backup(line.split()))
    backup_lst.sort(key=lambda x: x.submit, reverse=False)   # 按提交时间排序
    return backup_lst

# 补充：每次调度时可以提交新的作业
def add_backup(backup_lst: list, now):
    res = input('当前时间%s, 在后备队列中添加一个作业？（Y/N）：'% now)
    if res == 'Y':
        print('当前后备队列：')
        for back in backup_lst:
            print(back.num, back.name, back.submit.time(), back.need)
        s = input('请输入“编号 名称 提交时间 要求时间”，以空格分割(1 JA 02:40 20)：').split()
        backup_lst.append(backup(s))
        backup_lst.sort(key=lambda x: x.submit, reverse=False)   # 按提交时间排序
        return True
    return False

if __name__ == '__main__':
    path = 'test.txt'
    backup_lst = readfile(path)
    job_lst = Schedule(backup_lst)
    output(job_lst)