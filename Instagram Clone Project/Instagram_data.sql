/*We want to reward our users who have been around the longest.  
Find the 5 oldest users.*/

CREATE DATABASE IF NOT EXISTS INSTAGRAM_CLONE;
USE INSTAGRAM_CLONE;

/*We want to reward our users who have been around the longest.  
Find the 5 oldest users.*/
SELECT * FROM users
    ORDER BY created_at 
        LIMIT 5;


/*What day of the week do most users register on?
We need to figure out when to schedule an ad campgain*/

SELECT * FROM
 (SELECT 
    DAYNAME(created_at) AS day,
        COUNT(*) AS total,
            DENSE_RANK() OVER( ORDER BY COUNT(*)  DESC) AS ROW_NUM
                FROM users
                    GROUP BY day) AS A
WHERE ROW_NUM = 1;


/*We want to target our inactive users with an email campaign.
Find the users who have never posted a photo*/

SELECT U.USERNAME AS NAME FROM USERS U
    LEFT JOIN PHOTOS P ON U.ID= P.USER_ID
        WHERE P.IMAGE_URL IS NULL;


/*We're running a new contest to see who can get the most likes on a single photo. CONFUSED IN THIS
WHO WON??!!*/

SELECT * FROM USERS;
SELECT * FROM PHOTOS WHERE ID =145;
SELECT * FROM LIKES;
        
select U.username, P.id,count(P.image_url) as total_likes from users U 
	 join photos P on U.id= P.User_id
		join likes L on U.id = L.user_id
			group by U.username
				order by total_likes desc;
                                
/*Our Investors want to know...
How many times does the average user post?*/
/*total number of photos/total number of users*/

SELECT ROUND((SELECT COUNT(*)FROM photos)/(SELECT COUNT(*) FROM users),2) AS AVERAGE_USERS_POST ;

/*user ranking by postings higher to lower*/

SELECT U.USERNAME , COUNT(P.IMAGE_URL) AS IMAGE
FROM USERS U 
    INNER JOIN PHOTOS P
        ON U.ID = P.USER_ID
            GROUP BY USERNAME
                ORDER BY IMAGE DESC;


/*Total Posts by users (longer versionof SELECT COUNT(*)FROM photos) */
             
SELECT  SUM(TABLE_A.IMAGE) AS TOTAL_POSTS FROM   
(SELECT U.USERNAME, COUNT(P.IMAGE_URL) AS IMAGE
	FROM USERS U
		LEFT JOIN PHOTOS P
			ON U.ID = P.USER_ID
				GROUP BY U.USERNAME
					ORDER BY IMAGE DESC) AS TABLE_A;

/*total numbers of users who have posted at least one time */

SELECT COUNT(DISTINCT(users.id)) AS total_number_of_users_with_posts
	FROM users
		INNER JOIN photos
			ON users.id = photos.user_id;

/*A brand wants to know which hashtags to use in a post
What are the top 5 most commonly used hashtags?*/

SELECT COUNT(PT.TAG_ID) AS TAG_COUNT, T.TAG_NAME FROM PHOTO_TAGS PT
    INNER JOIN TAGS T
        ON PT.TAG_ID = T.ID
            GROUP BY TAG_NAME
                ORDER BY TAG_COUNT DESC;

/*We have a small problem with bots on our site...
Find users who have liked every single photo on the site*/

SELECT DISTINCT(U.username) AS name FROM users U
	 JOIN  Likes L 
		ON U.id = L.user_id
			GROUP BY username;
              
/*We also have a problem with celebrities
Find users who have never commented on a photo*/

SELECT U.username, C.comment_text
	FROM users U 
		LEFT JOIN comments C 
			ON U.id = C.user_id
				WHERE comment_text IS NULL;

-- Mega Challenges               

/*Are we overrun with bots and celebrity accounts?
Find the percentage of our users who have either never commented on a photo or have commented on photos before*/

SELECT TABLE_A.COUNT_A AS USER_NOT_COMMENTED,
    ROUND(TABLE_A.COUNT_A/(SELECT COUNT(*) FROM USERS),2)*100 AS PERCENTAGE_NOT_COMMENTED,
        TABLE_B.COUNT_B AS USER_COMMENTED,
            ROUND(TABLE_B.COUNT_B/(SELECT COUNT(*) FROM USERS),2)*100 AS PERCENTAGE_COMMENTED
FROM
  (SELECT COUNT(*) AS COUNT_A FROM (SELECT U.USERNAME , COUNT(C.PHOTO_ID) AS PHOTO_COUNT , COUNT(C.COMMENT_TEXT) AS COMMENT_COUNT FROM USERS U
    LEFT JOIN COMMENTS C
        ON U.ID = C.USER_ID
            GROUP BY USERNAME) AS A
                WHERE COMMENT_COUNT = 0) AS TABLE_A
                   JOIN  
(SELECT COUNT(*) AS COUNT_B FROM (SELECT U.USERNAME, COUNT(C.PHOTO_ID) AS PHOTO_COUNTB, COUNT(C.COMMENT_TEXT) AS COMMENT_COUNTB FROM USERS U
    LEFT JOIN COMMENTS C
        ON U.ID = C.USER_ID
            GROUP BY USERNAME) AS B
                WHERE COMMENT_COUNTB != 0) AS TABLE_B ; 










