<?php require_once('Connections/localhost.php'); ?>
<?php require_once('Connections/functions.php'); ?>
<?php

Class News
{
	var $id;
	var $header;
	var $title;
	var $body;
	var $url;
	var $public;

	function News( $row )
	{
		$this->id = $row["id"];
		$this->header = $row["header"];
		$this->title = $row["title"];
		$this->body = $row["body"];
		$this->url = $row["url"];
		$this->public = $row["public"];

	}


}


function getPublic()
{
	global $database_localhost, $localhost;
	mysql_select_db($database_localhost, $localhost);
	$query = "SELECT * FROM news where public=1";
	
	$result = mysql_query($query, $localhost) or die(mysql_error());
	
	$news = array();
	
	while ($row = mysql_fetch_assoc($result)) 
	{
		array_push($news, new News($row));
	}
	
	return $news;
	
}
?>


<?php

//header('Content-Type: text/xml');

echo json_encode( getPublic() );

?>