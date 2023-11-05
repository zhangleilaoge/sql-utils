import re
import datetime
import os
import argparse

def read_file(file_path):
    try:
        with open(file_path, "r", encoding="utf-8") as file:
            file_content = file.read()
        return file_content
    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return None
    except Exception as e:
        print(f"An error occurred while reading the file: {str(e)}")
        return None


def write_file(file_path, content):
    try:
        with open(file_path, "w", encoding="utf-8") as file:
            file.write(content)
    except Exception as e:
        print(f"An error occurred while writing the file: {str(e)}")


def process_date(file_content):
    current_date = datetime.date.today()
    # 使用正则表达式查找形如“2023xx”的日期字符串,逐个替换日期字符串为当前年月
    date_pattern = r"202(?:[0-3])(?:0[1-9]|1[0-2])"
    date_matches = re.findall(date_pattern, file_content)
    for date_str in date_matches:
        current_year_month = current_date.strftime("%Y%m")
        file_content = file_content.replace(date_str, current_year_month)

    # 使用正则表达式查找形如“2023-10-31”的日期字符串,逐个替换日期字符串为当前年月
    date_pattern = r"202(?:[0-3])-(?:0[1-9]|1[0-2])-(?:[0-3][0-9])"
    date_matches = re.findall(date_pattern, file_content)
    for date_str in date_matches:
        current_year_month_day = current_date.strftime("%Y-%m-%d")
        file_content = file_content.replace(date_str, current_year_month_day)

    return file_content


# 主函数~
def main():
    file_path = input("Enter the sql file name to process: ")

    source_file_path = f"./sqls/{file_path}"
    output_path = "./dist"
    file_content = read_file(source_file_path)

    # 生成新文件路径
    output_file_path = f"{output_path}/{file_path}"

    # 如果目录不存在，创建它
    if not os.path.exists(output_path):
        os.makedirs(output_path)

    write_file(output_file_path, process_date(file_content))


main()
