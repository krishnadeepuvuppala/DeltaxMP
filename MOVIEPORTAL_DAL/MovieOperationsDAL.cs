using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace MOVIEPORTAL_DAL
{
    public class MovieOperationsDAL
    {

        /// <summary>
        /// Retrives Crew details
        /// </summary>
        /// <param name="MovieID"></param>
        /// <returns>Datatable</returns>
        public DataTable GetMovieCrew(int MovieID)
        {
            DataTable dtCrewList = new DataTable();
            SqlParameter[] arParms = new SqlParameter[1];
            arParms[0] = new SqlParameter("@MOVIE_ANID", SqlDbType.Int);
            arParms[0].Value = MovieID;

            try
            {
                dtCrewList = new SQLHelper().ExecDataTable("usp_GetCrewUnionByMovieID", arParms);
            }
            catch (Exception ex)
            {
            }
            return dtCrewList;
        }

        /// <summary>
        /// Reetrives movies list
        /// </summary>
        /// <returns>DataTable</returns>
        public DataTable GetMoviesList()
        {
            DataTable dtMoviesList = new DataTable();
            try
            {
                dtMoviesList = new SQLHelper().ExecDataTable("usp_ReturnMovieList");
                for (int i = 0; i < dtMoviesList.Rows.Count; i++)
                {
                    string actors = dtMoviesList.Rows[i]["Actors"].ToString();
                    if (actors.Length > 0)
                    {
                        string[] arr = actors.TrimEnd(',').Split(',');
                        if (arr.Length > 0)
                        {
                            string actorNames = string.Empty;
                            for (int j = 0; j < arr.Length; j++)
                            {
                                DataTable dtActors = GetActorsByAnids(arr[j]);
                                foreach (DataRow dr in dtActors.Rows)
                                {
                                    actorNames += dr["ACTOR_NAME"].ToString() + ",";
                                }
                            }
                            dtMoviesList.Rows[i]["Actors"] = actorNames.TrimEnd(',');
                        }
                    }

                }
            }
            catch (Exception ex)
            {
            }
            return dtMoviesList;
        }

        /// <summary>
        /// Retrives producers list
        /// </summary>
        /// <returns>DataTable</returns>
        public DataTable GetProducersList()
        {
            DataTable dtProducersList = new DataTable();
            try
            {
                dtProducersList = new SQLHelper().ExecDataTable("usp_ReturnProducerList");
            }
            catch (Exception ex)
            {
            }
            return dtProducersList;
        }

        public DataTable GetActorsByAnids(string actorsIds)
        {
            DataTable dtCrewList = new DataTable();
            SqlParameter[] arParms = new SqlParameter[1];
            arParms[0] = new SqlParameter("@ACTORS_IDS", SqlDbType.NVarChar);
            arParms[0].Value = actorsIds;

            try
            {
                dtCrewList = new SQLHelper().ExecDataTable("usp_ReturnMovieActorsByID", arParms);
            }
            catch (Exception ex)
            {
            }
            return dtCrewList;
        }

        /// <summary>
        /// Retrives Actors list
        /// </summary>
        /// <returns>DataTable</returns>
        public DataTable GetActorsList()
        {
            DataTable dtActorsList = new DataTable();
            try
            {
                dtActorsList = new SQLHelper().ExecDataTable("usp_ReturnActorsList");
            }
            catch (Exception ex)
            {
            }
            return dtActorsList;
        }

        /// <summary>
        /// Updates the movie details
        /// </summary>
        /// <param name="MOVIE_ANID"></param>
        /// <param name="CREW_ANID"></param>
        /// <param name="ACTORS_ANIDS"></param>
        /// <param name="PRODUCER_ANID"></param>
        /// <param name="MOVIE_NAME"></param>
        /// <param name="UPDATED_BY"></param>
        /// <returns>Number of rows effected</returns>
        public int UpdateMovie(int MOVIE_ANID, int CREW_ANID, string ACTORS_ANIDS, int PRODUCER_ANID, string MOVIE_NAME, string UPDATED_BY)
        {
            int iRowsEffected = 0;
            try
            {
                try
                {
                    SqlParameter[] arParms = new SqlParameter[6];

                    arParms[0] = new SqlParameter("@MOVIE_ANID", SqlDbType.Int);
                    arParms[0].Value = MOVIE_ANID;

                    arParms[1] = new SqlParameter("@CREW_ANID", SqlDbType.Int);
                    arParms[1].Value = CREW_ANID;

                    arParms[2] = new SqlParameter("@ACTORS", SqlDbType.NVarChar, 4000);
                    arParms[2].Value = ACTORS_ANIDS;

                    arParms[3] = new SqlParameter("@PRODUCER_ANID", SqlDbType.Int);
                    arParms[3].Value = PRODUCER_ANID;

                    arParms[4] = new SqlParameter("@MOVIE_NAME", SqlDbType.NVarChar, 400);
                    arParms[4].Value = MOVIE_NAME;

                    arParms[5] = new SqlParameter("@UPDATED_BY", SqlDbType.NVarChar, 600);
                    arParms[5].Value = UPDATED_BY;



                    iRowsEffected = Convert.ToInt32(new SQLHelper().ExecScalarProc("usp_UpdateMovie", arParms));

                }
                catch (SqlException exSQL)
                {
                    iRowsEffected = -1;
                }
            }
            catch (Exception ex)
            {
                iRowsEffected = -1;
            }
            return iRowsEffected;
        }

        /// <summary>
        /// Creates producer
        /// </summary>
        /// <param name="PRODUCER_NAME"></param>
        /// <param name="PRODUCER_GENDER"></param>
        /// <param name="PRODUCER_DOB"></param>
        /// <param name="PRODUCER_BIO"></param>
        /// <param name="CREATED_BY"></param>
        /// <returns>Identity of the created record.</returns>
        public int CreateProducer(string PRODUCER_NAME, string PRODUCER_GENDER, string PRODUCER_DOB, string PRODUCER_BIO, string CREATED_BY)
        {
            int iRowsEffected = 0;
            try
            {
                try
                {

                    SqlParameter[] arParms = new SqlParameter[5];

                    arParms[0] = new SqlParameter("@PRODUCER_NAME", SqlDbType.NVarChar, 600);
                    arParms[0].Value = PRODUCER_NAME;

                    arParms[1] = new SqlParameter("@PRODUCER_GENDER", SqlDbType.Char, 1);
                    arParms[1].Value = PRODUCER_GENDER;

                    arParms[2] = new SqlParameter("@PRODUCER_DOB", SqlDbType.NVarChar, 500);
                    arParms[2].Value = PRODUCER_DOB;

                    arParms[3] = new SqlParameter("@PRODUCER_BIO", SqlDbType.NVarChar, 4000);
                    arParms[3].Value = PRODUCER_BIO;

                    arParms[4] = new SqlParameter("@CREATED_BY", SqlDbType.NVarChar, 600);
                    arParms[4].Value = CREATED_BY;



                    iRowsEffected = Convert.ToInt32(new SQLHelper().ExecScalarProc("usp_CreateProducer", arParms));

                }
                catch (SqlException exSQL)
                {
                    iRowsEffected = -1;
                }
            }
            catch (Exception ex)
            {
                iRowsEffected = -1;
            }
            return iRowsEffected;
        }

        /// <summary>
        /// Creates Actor
        /// </summary>
        /// <param name="ACTOR_NAME"></param>
        /// <param name="ACTOR_GENDER"></param>
        /// <param name="ACTOR_DOB"></param>
        /// <param name="ACTOR_BIO"></param>
        /// <param name="CREATED_BY"></param>
        /// <returns>Identity of the created record.</returns>
        public int CreateActor(string ACTOR_NAME, string ACTOR_GENDER, string ACTOR_DOB, string ACTOR_BIO, string CREATED_BY)
        {
            int iRowsEffected = 0;
            try
            {
                try
                {

                    SqlParameter[] arParms = new SqlParameter[5];

                    arParms[0] = new SqlParameter("@ACTOR_NAME", SqlDbType.NVarChar, 600);
                    arParms[0].Value = ACTOR_NAME;

                    arParms[1] = new SqlParameter("@ACTOR_GENDER", SqlDbType.Char, 1);
                    arParms[1].Value = ACTOR_GENDER;

                    arParms[2] = new SqlParameter("@ACTOR_DOB", SqlDbType.NVarChar, 500);
                    arParms[2].Value = ACTOR_DOB;

                    arParms[3] = new SqlParameter("@ACTOR_BIO", SqlDbType.NVarChar, 4000);
                    arParms[3].Value = ACTOR_BIO;

                    arParms[4] = new SqlParameter("@CREATED_BY", SqlDbType.NVarChar, 600);
                    arParms[4].Value = CREATED_BY;



                    iRowsEffected = Convert.ToInt32(new SQLHelper().ExecScalarProc("usp_CreateActor", arParms));

                }
                catch (SqlException exSQL)
                {
                    iRowsEffected = -1;
                }
            }
            catch (Exception ex)
            {
                iRowsEffected = -1;
            }
            return iRowsEffected;
        }

        /// <summary>
        /// Creates Movie
        /// </summary>
        /// <param name="MOVIE_NAME"></param>
        /// <param name="MOVIE_YOR"></param>
        /// <param name="MOVIE_PLOT"></param>
        /// <param name="MOVIE_POSTER"></param>
        /// <param name="PRODUCER_ANID"></param>
        /// <param name="ACTORS_ANIDS"></param>
        /// <param name="CREATED_BY"></param>
        /// <returns>Identity of the created record.</returns>
        public int CreateMovie(string MOVIE_NAME, string MOVIE_YOR, string MOVIE_PLOT, string MOVIE_POSTER, int PRODUCER_ANID, string ACTORS_ANIDS, string CREATED_BY)
        {
            int iRowsEffected = 0;
            try
            {
                try
                {

                    SqlParameter[] arParms = new SqlParameter[7];

                    arParms[0] = new SqlParameter("@MOVIE_NAME", SqlDbType.NVarChar, 400);
                    arParms[0].Value = MOVIE_NAME;

                    arParms[1] = new SqlParameter("@MOVIE_YOR", SqlDbType.NVarChar, 100);
                    arParms[1].Value = MOVIE_YOR;

                    arParms[2] = new SqlParameter("@MOVIE_PLOT", SqlDbType.NVarChar, 4000);
                    arParms[2].Value = MOVIE_PLOT;

                    arParms[3] = new SqlParameter("@MOVIE_POSTER", SqlDbType.NVarChar);
                    arParms[3].Value = MOVIE_POSTER;

                    arParms[4] = new SqlParameter("@PRODUCER_ANID", SqlDbType.Int);
                    arParms[4].Value = PRODUCER_ANID;

                    arParms[5] = new SqlParameter("@ACTORS_ANIDS", SqlDbType.NVarChar);
                    arParms[5].Value = ACTORS_ANIDS;

                    arParms[6] = new SqlParameter("@CREATED_BY", SqlDbType.NVarChar, 600);
                    arParms[6].Value = CREATED_BY;



                    iRowsEffected = Convert.ToInt32(new SQLHelper().ExecScalarProc("usp_CreateMovie", arParms));

                }
                catch (SqlException exSQL)
                {
                    iRowsEffected = -1;
                }
            }
            catch (Exception ex)
            {
                iRowsEffected = -1;
            }
            return iRowsEffected;
        }


    }
}