using System;
using System.Collections.Generic;
using System.Web;
using System.Linq;
using System.Web.Http;
using System.Data;
using Newtonsoft.Json.Linq;
//using System.Text.RegularExpressions;
using System.Web.Script.Serialization;
using MOVIEPORTAL_DAL;
using System.Data.SqlClient;
using System.Globalization;
//using System.Configuration;

namespace MoviePortalDeltaX.Controllers
{
    public class MoviePortalController : ApiController
    {

        internal class MovieDetails
        {
            public string Name { get; set; }
            public string Year { get; set; }
            public string Actors { get; set; }
            public string Producer { get; set; }
            public string Poster { get; set; }
            public string Actions { get; set; }
        }

        // GET: MoviePortal
        [HttpGet]
        [ActionName("getmoviedetails")]
        public object getMovieDetails(string movieid)
        {
            try
            {
                int MOVIE_ID = 0;
                MovieOperationsDAL mo_dal = new MovieOperationsDAL();
                DataTable dtMovieDetails = new DataTable();
                if (movieid.Length > 0)
                    MOVIE_ID = int.Parse(movieid);
                else
                {
                    return new { Message = "error", MessageReason = "No movie found" };
                }
                dtMovieDetails = mo_dal.GetMovieCrew(MOVIE_ID);

                if (dtMovieDetails.Rows.Count > 0)
                    return new { Message = "success", MovieDetails = DataTableToJSONWithJavaScriptSerializer(dtMovieDetails) };
                else
                    return new { message = "error", MessageReason = "No movie avilable" };
            }
            catch (Exception ex)
            {
                string error = " API - getmoviedetails " + ex.Message;
                return new { Message = "error", MessageReason = "There was some problem loading the data. Please try again! <br>  " + error };
            }

        }

        [Route("api/MoviePortal/getmovieslist")]
        [HttpGet]
        [ActionName("getmovieslist")]
        public object getMoviesList()
        {
            try
            {
                MovieOperationsDAL mo_dal = new MovieOperationsDAL();
                DataTable dtMovieDetails = new DataTable();
                List<MovieDetails> lstMovieDetails= new List<MovieDetails>();
                dtMovieDetails = mo_dal.GetMoviesList();
                for (int i = 0; i < dtMovieDetails.Rows.Count; i++)
                {
                    MovieDetails md = new MovieDetails();
                    md.Name = dtMovieDetails.Rows[i]["Name"].ToString();
                    md.Year = dtMovieDetails.Rows[i]["Year"].ToString();
                    md.Actors = dtMovieDetails.Rows[i]["Actors"].ToString();
                    md.Producer = dtMovieDetails.Rows[i]["Producer"].ToString();
                    md.Poster = String.Format("<div align=center><img src='{0}' width='50' vspace='5'></div>", dtMovieDetails.Rows[i]["Poster"].ToString());
                    md.Actions = dtMovieDetails.Rows[i]["Actions"].ToString();
                    lstMovieDetails.Add(md);
                }
                
                return new { Message = "Success", MovieList = lstMovieDetails };
            }
            catch (Exception ex)
            {
                string error = " API - getmovieslist " + ex.Message;
                return new { Message = "error", MessageReason = "There was some problem loading data. Please refresh try again! <br>" + error };
            }
        }

        [Route("api/MoviePortal/getproducerlist")]
        [HttpGet]
        [ActionName("getproducerlist")]
        public object getProducerList()
        {
            try
            {
                MovieOperationsDAL mo_dal = new MovieOperationsDAL();
                DataTable dtProducerList = new DataTable();
                dtProducerList = mo_dal.GetProducersList();
                if (dtProducerList.Rows.Count > 0)
                    return new { Message = "Success", ProducerList = DataTableToJSONWithJavaScriptSerializer(dtProducerList) };
                else
                    return new { Message = "error", MessageReason = "No Producer avilable." };
            }
            catch (Exception ex)
            {
                string error = " API - getproducerlist " + ex.Message;
                return new { Message = "error", MessageReason = "There was some problem loading data. Please refresh try again! <br>" + error };
            }
        }

        [Route("api/MoviePortal/getactorlist")]
        [HttpGet]
        [ActionName("getactorlist")]
        public object getActorList()
        {
            try
            {
                MovieOperationsDAL mo_dal = new MovieOperationsDAL();
                DataTable dtActorsList = new DataTable();
                dtActorsList = mo_dal.GetActorsList();
                if (dtActorsList.Rows.Count > 0)
                    return new { Message = "Success", ActorsList = DataTableToJSONWithJavaScriptSerializer(dtActorsList) };
                else
                    return new { Message = "error", MessageReason = "No Actor avilable." };
            }
            catch (Exception ex)
            {
                string error = " API - getactorlist " + ex.Message;
                return new { Message = "error", MessageReason = "There was some problem loading data. Please refresh try again! <br>" + error };
            }
        }


        [HttpPost]
        [ActionName("updatemovie")]
        public object UpdateMovie(JObject json)
        {
            try
            {
                MovieOperationsDAL mo_dal = new MovieOperationsDAL();
                DataTable dtActorsList = new DataTable();
                int MOVIE_ANID = int.Parse(json["MOVIE_ANID"].ToString());
                int CREW_ANID = int.Parse(json["CREW_ANID"].ToString());
                string ACTORS_ANIDS = (json["ACTORS_ANIDS"].ToString());
                int PRODUCER_ANID = int.Parse(json["PRODUCER_ANID"].ToString());
                string MOVIE_NAME = (json["MOVIE_NAME"].ToString());
                int iRowsEffected = mo_dal.UpdateMovie(MOVIE_ANID, CREW_ANID, ACTORS_ANIDS, PRODUCER_ANID, MOVIE_NAME, "Admin");
                if (iRowsEffected > 0)
                    return new { Message = "Success", MessageReason = "Successfully Updated movie details." };
                else
                    return new { Message = "error", MessageReason = "Update failed." };
            }
            catch (Exception ex)
            {
                string error = " API - updatemovie " + ex.Message;
                return new { Message = "error", MessageReason = "There was some problem. Please refresh try again! <br>" + error };
            }
        }

        [Route("api/MoviePortal/createmovie")]
        [HttpPost]
        [ActionName("createmovie")]
        public object CreateMovie(JObject json)
        {
            try
            {
                MovieOperationsDAL mo_dal = new MovieOperationsDAL();
                DataTable dtActorsList = new DataTable();
                string MOVIE_NAME = (json["MOVIE_NAME"].ToString());
                string MOVIE_YOR = (json["MOVIE_YOR"].ToString());
                string MOVIE_PLOT = (json["MOVIE_PLOT"].ToString());
                string MOVIE_POSTER = (json["MOVIE_POSTER"].ToString());
                int PRODUCER_ANID = int.Parse(json["PRODUCER_ANID"].ToString());
                string ACTORS_ANIDS = (json["ACTORS_ANIDS"].ToString());
                int iRowsEffected = mo_dal.CreateMovie(MOVIE_NAME, MOVIE_YOR, MOVIE_PLOT, MOVIE_POSTER, PRODUCER_ANID, ACTORS_ANIDS, "Admin");
                if (iRowsEffected > 0)
                    return new { Message = "success", MessageReason = "Successfully Created movie." };
                else
                    return new { Message = "error", MessageReason = "Insert failed." };
            }
            catch (Exception ex)
            {
                string error = " API - updatemovie " + ex.Message;
                return new { Message = "error", MessageReason = "There was some problem. Please refresh try again! <br>" + error };
            }
        }

        [Route("api/MoviePortal/createactor")]
        [HttpPost]
        [ActionName("createactor")]
        public object CreateActor(JObject json)
        {
            try
            {
                MovieOperationsDAL mo_dal = new MovieOperationsDAL();
                DataTable dtActorsList = new DataTable();
                string ACTOR_NAME = (json["ACTOR_NAME"].ToString());
                string ACTOR_GENDER = (json["ACTOR_GENDER"].ToString());
                string ACTOR_DOB = (json["ACTOR_DOB"].ToString());
                string ACTOR_BIO = (json["ACTOR_BIO"].ToString());

                int iRowsEffected = mo_dal.CreateActor(ACTOR_NAME, ACTOR_GENDER, ACTOR_DOB, ACTOR_BIO, "Admin");
                if (iRowsEffected > 0)
                    return new { Message = "Success", MessageReason = "Successfully Created movie." };
                else
                    return new { Message = "error", MessageReason = "Insert failed." };
            }
            catch (Exception ex)
            {
                string error = " API - updatemovie " + ex.Message;
                return new { Message = "error", MessageReason = "There was some problem. Please refresh try again! <br>" + error };
            }
        }

        [Route("api/MoviePortal/createproducer")]
        [HttpPost]
        [ActionName("createproducer")]
        public object CreateProducer(JObject json)
        {
            try
            {
                MovieOperationsDAL mo_dal = new MovieOperationsDAL();
                DataTable dtActorsList = new DataTable();
                string PRODUCER_NAME = (json["PRODUCER_NAME"].ToString());
                string PRODUCER_GENDER = (json["PRODUCER_GENDER"].ToString());
                string PRODUCER_DOB = (json["PRODUCER_DOB"].ToString());

                string PRODUCER_BIO = (json["PRODUCER_BIO"].ToString());

                int iRowsEffected = mo_dal.CreateProducer(PRODUCER_NAME, PRODUCER_GENDER, PRODUCER_DOB, PRODUCER_BIO, "Admin");
                if (iRowsEffected > 0)
                    return new { Message = "Success", MessageReason = "Successfully Created movie." };
                else
                    return new { Message = "error", MessageReason = "Insert failed." };
            }
            catch (Exception ex)
            {
                string error = " API - updatemovie " + ex.Message;
                return new { Message = "error", MessageReason = "There was some problem. Please refresh try again! <br>" + error };
            }
        }

        public static string DataTableToJSONWithJavaScriptSerializer(DataTable table)
        {
            JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
            List<Dictionary<string, object>> parentRow = new List<Dictionary<string, object>>();
            Dictionary<string, object> childRow;
            foreach (DataRow row in table.Rows)
            {
                childRow = new Dictionary<string, object>();
                foreach (DataColumn col in table.Columns)
                {
                    childRow.Add(col.ColumnName, row[col]);
                }
                parentRow.Add(childRow);
            }
            return jsSerializer.Serialize(parentRow);
        }
    }
}
