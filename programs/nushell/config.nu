$env.SHELL = (which nu | get path.0)
$env.OLLAMA_API_BASE = http://127.0.0.1:11435
alias aider = aider --model ollama_chat/qwen2.5:3b

