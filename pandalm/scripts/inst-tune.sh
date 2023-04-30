#export CUDA_VISIBLE_DEVICES=4,5,6,7
git clone https://github.com/WeOpenML/PandaLM.git
cd PandaLM/pandalm
if [ ! -f "./assets/alpaca_data.json" ];then
  echo "alpaca data does not exist"
  wget -P ./assets https://raw.githubusercontent.com/tatsu-lab/stanford_alpaca/main/alpaca_data.json
  else
  echo "alpaca data exists"
fi
deepspeed  --master_port=2023  inst-tune.py    --model_name_or_path facebook/opt-6.7b --output_dir ./output/llama-7b  --data_path ./assets/alpaca_data.json --bf16 True    --num_train_epochs 3     --per_device_train_batch_size 2   --per_device_eval_batch_size 2     --gradient_accumulation_steps 8     --evaluation_strategy "no"     --save_strategy "steps"     --save_steps 2000     --save_total_limit 1     --learning_rate 2e-5     --weight_decay 0.     --warmup_ratio 0.03     --lr_scheduler_type "cosine"     --logging_steps 1   --peft_model none --deepspeed assets/ds_config_zero2.json --model_max_length 1024 --report_to none --use_raw_data False