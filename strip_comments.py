import os

def strip_comments(content):
    lines = content.split('\n')
    
    header_lines = []
    rest_lines = []
    
    in_header = True
    for line in lines:
        if in_header:
            if line.startswith('//'):
                header_lines.append(line)
                continue
            else:
                in_header = False
                
        if not in_header:
            rest_lines.append(line)
            
    new_rest = []
    for line in rest_lines:
        stripped = line.strip()
        if stripped.startswith('//'):
            continue
            
        in_string = False
        new_line_chars = []
        i = 0
        has_comment = False
        while i < len(line):
            c = line[i]
            if c == '"' and (i == 0 or line[i-1] != '\\'):
                in_string = not in_string
            if not in_string and c == '/' and i + 1 < len(line) and line[i+1] == '/':
                has_comment = True
                break
            new_line_chars.append(c)
            i += 1
            
        cleaned_line = "".join(new_line_chars)
        if has_comment:
            cleaned_line = cleaned_line.rstrip()
            
        if cleaned_line == "" and stripped != "":
            continue
            
        new_rest.append(cleaned_line)
            
    return '\n'.join(header_lines + new_rest)

def process_dir(directory):
    for root, dirs, files in os.walk(directory):
        for f in files:
            if f.endswith('.swift'):
                path = os.path.join(root, f)
                with open(path, 'r', encoding='utf-8') as file:
                    content = file.read()
                
                new_content = strip_comments(content)
                
                with open(path, 'w', encoding='utf-8') as file:
                    file.write(new_content)

process_dir('/Users/moca/Documents/Coding/studing/swift Projects/WeatherCast App/WeatherCast App')
