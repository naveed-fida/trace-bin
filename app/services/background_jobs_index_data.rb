class BackgroundJobsIndexData
  def initialize(app_bin_id)
    @app_bin_id = app_bin_id
  end

  def fetch!
    tuples = fetch_tuples
    process_tuples tuples
  end

  private

  def fetch_tuples
    sql = <<~SQL
      SELECT
        name AS job_name,
        avg(duration) AS avg_duration,
        count(*) AS hits,
        avg((
          SELECT sum(duration)
          FROM jsonb_to_recordset(events->'sql') AS x(duration NUMERIC)
        )) AS avg_time_in_sql,
        avg((
          -- View events happen within each other, so we just need to take the
          -- highest value here.
          SELECT max(duration)
          FROM jsonb_to_recordset(events->'view') AS x(duration NUMERIC)
        )) AS avg_time_in_view,
        avg((
          SELECT sum(duration)
          FROM
            jsonb_to_recordset(events->'controller_action')
              AS x(duration NUMERIC)
        )) AS avg_time_in_controller,
        avg((
          SELECT sum(duration)
          FROM jsonb_to_recordset(events->'other') AS x(duration NUMERIC)
        )) AS avg_time_in_other
      FROM cycle_transactions
      WHERE
        app_bin_id = #{ActiveRecord::Base.sanitize @app_bin_id} AND
        transaction_type = 'background_job' AND
        start > (current_timestamp - interval '1 day')
      GROUP BY job_name
      ORDER BY hits DESC;
    SQL

    ActiveRecord::Base.connection.execute sql
  end

  def process_tuples(tuples)
    tuples.to_a.map do |tuple|
      [
        tuple['job_name'],
        tuple['avg_duration'].to_f.round(2),
        tuple['hits'],
        tuple['avg_time_in_sql'].to_f.round(2),
        tuple['avg_time_in_view'].to_f.round(2),
        tuple['avg_time_in_controller'].to_f.round(2),
        tuple['avg_time_in_other'].to_f.round(2)
      ]
    end
  end
end