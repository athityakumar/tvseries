begin
  if `git status`.include? "fatal: Not a git repository"
    `git init`
    puts "Git init - done."
  else
    puts "Git init - checked."  
  end  

  if `git remote -v`.empty?
    puts "Paste remote git URL : "
    remote = gets.chomp
    `git remote add origin #{remote}`
    puts "Git remote - done."
  else
    puts "Git remote - checked."
  end

  if (`git status`.include? "Changes not staged for commit:") || (`git status`.include? "Untracked files:")
    `git add --all`
    puts "Git add - done."
  else
    puts "Git add - checked."  
  end  

  if `git status`.include? "Changes to be committed:"
    puts "Enter commit message : "
    message = gets.chomp
    if message.empty?
      message = `git status`.split('(use "git reset HEAD <file>..." to unstage)')[1].strip.gsub("\n",",")+"."
      `git commit -m "Ruby-git commit - #{message}"`
    else
      `git commit -m "#{message}"`
    end  
    
    puts "Git commit - done."  
  else
    puts "Git commit - checked."  
  end  

  active_branch = ""

  `git branch`.split("\n").each do |each_branch|
    if each_branch.include? "* "
      active_branch = each_branch.gsub("* ","")
    end
  end
  
  branches = `git branch`.gsub("* ","").gsub("  ","").split("\n")

  if branches.count == 1
    branch = active_branch
  else
    i = 0
    while i < branches.count do
      puts "#{i+1} : #{branches[i]}"
      i = i+1
    end
    puts "Choose a branch (#{active_branch} is default) : "
    branch_number = gets.chomp.to_i
    if branch_number > 0 && branch_number <= branches.count
      branch = branches[branch_number-1]
      puts "Succesfully chosen #{branch} branch."
    else
      puts "Invalid branch. Choosing active branch #{active_branch} to push to."
      branch = active_branch
    end
  end

  if `git status`.include? "nothing to commit, working directory clean"
    `git push origin #{branch}`
    puts "Git push - done."  
  else
    puts "Git push - checked."  
  end  
rescue Exception => e
  puts "Error occured : #{e.to_s}"
end
  