#INSERT  INTO `{{site_dbprefix}}users`   (`name`, `username`, `password`, `params`)
#SELECT * FROM (SELECT 'Administrator', '{{joomla_login}}', md5('{{joomla_pass}}'), '') AS TMP
#WHERE NOT EXISTS (
#        select `username`
#        from `{{site_dbprefix}}users`
#        where `username` = '{{joomla_login}}'
#) LIMIT 1;


#INSERT INTO `{{site_dbprefix}}user_usergroup_map` (`user_id`,`group_id`) VALUES (LAST_INSERT_ID(),'8')
#WHERE NOT EXISTS (select `username` from `{{site_dbprefix}}users` where `username` = '{{joomla_login}}');


INSERT  INTO `{{site_dbprefix}}users`   (`name`, `username`, `password`, `params`) VALUES ('Administrator', '{{joomla_login}}', md5('{{joomla_pass}}'), '');
INSERT INTO `{{site_dbprefix}}user_usergroup_map` (`user_id`,`group_id`) VALUES (LAST_INSERT_ID(),'8');
