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
		$this->url = isset($row["url"]) ? $row["url"] : '';
		$this->public = $row["public"];
		$this->orderid = $row["orderid"];
	}
}


function update($data)
{
	global $database_localhost, $localhost;
	mysql_select_db($database_localhost, $localhost);
	$query = sprintf("UPDATE news SET header=%s, title=%s, body=%s, url=%s, public=%s, orderid=%s WHERE id=%s", GetSQLValueString($data->header,"text"),
																									GetSQLValueString($data->title,"text"),
																									GetSQLValueString($data->body,"text"),
																									GetSQLValueString($data->url,"text"),
																									GetSQLValueString($data->public,"int"),
																									GetSQLValueString($data->orderid,"int"),
																									GetSQLValueString($data->id,"int")) ;
	$message = mysql_query($query, $localhost) or die(mysql_error());
	$result = mysql_insert_id();
	return new Result( $result, $message, $query);
}
function insert($data)
{
	global $database_localhost, $localhost;
	
	mysql_select_db($database_localhost, $localhost);
	$query = sprintf("INSERT INTO news ( header, title, body, url, public, orderid ) VALUES (%s, %s, %s, %s, %s, %s)", 	GetSQLValueString($data->header,"text"),
																											GetSQLValueString($data->title,"text"),
																											GetSQLValueString($data->body,"text"),
																											GetSQLValueString($data->url,"text"),
																											GetSQLValueString($data->public,"int"),
																											GetSQLValueString($data->orderid,"int")) ;
	
	$message = mysql_query($query, $localhost) or die(mysql_error());
	$result = mysql_insert_id();
	return new Result( $result, $message, $query);
}
function select($id)
{
	global $database_localhost, $localhost;
	mysql_select_db($database_localhost, $localhost);
	$query = sprintf("SELECT * FROM news where id=%s", GetSQLValueString($id, "int")) ;
	$result = mysql_query($query, $localhost) or die(mysql_error());
	return mysql_fetch_assoc($result);
}
function selectAll()
{
	global $database_localhost, $localhost;
	mysql_select_db($database_localhost, $localhost);
	$query = "SELECT * FROM news ORDER BY orderid,id";
	$result = mysql_query($query, $localhost) or die(mysql_error());
	$news = array();
	while ($row = mysql_fetch_assoc($result)) 
	{
		array_push($news, new News($row));
	}
	
	return $news;
}

function selectAllPublic()
{
	global $database_localhost, $localhost;
	mysql_select_db($database_localhost, $localhost);
	$query = "SELECT * FROM news where public=1  ORDER BY orderid,id";
	$result = mysql_query($query, $localhost) or die(mysql_error());
	$news = array();
	while ($row = mysql_fetch_assoc($result)) 
	{
		array_push($news, new News($row));
	}
	
	return $news;
	
}
function init()
{
	if (isset($_SERVER['HTTP_X_HTTP_METHOD_OVERRIDE']))
		$method = $_SERVER['HTTP_X_HTTP_METHOD_OVERRIDE'];
	$values = json_decode(file_get_contents('php://input'), true);
	if (isset($values) && isset($method))
	{
		$values = new News( $values );
		
		
		switch ($method) {
			case 'PUT':
			
				if ($values->id>0) //id exists - run update
				{
					return update($values);

				} else //id does not exist - insert
				{
					return insert($values);
				}
				break;
			
			default:
				//default output all public news
				return ( selectAll() );
				break;
		}
	} else
	{
		return ( selectAll() );
	}

}
// access_key - header
//echo access();
// post/ put etc.

echo json_encode( init()  )
?>

