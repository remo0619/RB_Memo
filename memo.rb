require "csv" # CSVファイルを扱うためのライブラリを読み込んでいます

def memo_create(name) # メモ新規作成関数
    puts "メモの内容を入力してください。\n終了するときはCtrl+Dを押してください。"
    memo = readlines(chomp: true)

    CSV.open("#{name}.csv", 'w') do |csv|
        memo.each do |line| # 1行ずつ書き込み
            csv << [line] # []で囲むことで配列として書き込み
        end
    end
end

def memo_edit(name) # メモ編集関数
    row = CSV.read("#{name}.csv") # csvを全部読み込んで変数に格納
    row.each_with_index do |item, i| # 1行ずつ要素数を添えて表示
        puts "現在のメモ\n#{i + 1}:#{item}"
    end

    puts "削除したいメモの番号を入力してください。\n削除しない場合はEnterを押してください。\n終了するときはCtrl+Dを押してください。"
    delete_row = gets.to_i # ユーザーの入力値を取得し、数字へ変換しています
    if delete_row <= row.length && delete_row > 0
        row.delete_at(delete_row - 1)
        CSV.open("#{name}.csv", 'w') do |csv|
            row.each do |row|
                csv << row # rowはすでに配列なので[]はつけない
            end
        end
    else
        puts "その番号は存在しません。"
    end


    puts "追記したい内容を入力してください。\n終了するときはCtrl+Dを押してください。"
    memo = readlines(chomp: true)

    CSV.open("#{name}.csv", 'a') do |csv|
        memo.each do |line|
            csv << [line]
        end
    end
end

loop do
    puts "1 → 新規でメモを作成する / 2 → 既存のメモを編集する / 3 → やめる"
    memo_type = gets.to_i

    if memo_type == 1
        puts "新規でメモを作成します。\nファイル名を入力してください。(拡張子は不要です)"
        file_name = gets.chomp

        if !File.exist?("#{file_name}.csv") # ファイルが存在しない場合新規作成
            memo_create(file_name)
            break
        else # ファイルが存在する場合
            puts "#{file_name}.csvはすでに存在しています。上書きしますか？(y/n)"
            answer = gets.chomp
            if answer == "y"
                memo_create(file_name)
                break
            elsif answer == "n"
            else
                puts "規定の値(y,n)を入力しなさい"
            end
        end

    elsif memo_type == 2
        puts "既存のメモを編集します。\nファイル名を入力してください。(拡張子は不要です)"
        file_name = gets.chomp

        if File.exist?("#{file_name}.csv") # ファイルが存在する場合
            memo_edit(file_name)
            break
        else
            puts "#{file_name}.csvは存在しません。"
        end

    elsif memo_type == 3
        puts "終了します"
        break
    else
        puts "規定の値(1,2,3)を入力しなさい"
    end
end