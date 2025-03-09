vim.cmd.cnoreabbrev("<expr>", "q", "(getcmdtype()==#\":\"&&getcmdline()==#\"q\")?\"qa\":\"q\"")
vim.cmd.cnoreabbrev("<expr>", "q!", "(getcmdtype()==#\":\"&&getcmdline()==#\"q!\")?\"qa!\":\"q!\"")
vim.cmd.cnoreabbrev("<expr>", "wq", "(getcmdtype()==#\":\"&&getcmdline()==#\"wq\")?\"wqa\":\"wq\"")
vim.cmd.cnoreabbrev("<expr>", "wq!", "(getcmdtype()==#\":\"&&getcmdline()==#\"wq!\")?\"wqa!\":\"wq!\"")